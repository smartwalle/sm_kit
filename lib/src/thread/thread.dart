import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:sm_kit/src/queue/queue.dart';

typedef KIThreadCallback<Q, R> = R Function(Q value);

class KIPriorityThread extends _KIThread {
  KIPriorityThread._() : super(KIPriorityQueue<_TaskEntry>(_taskSorter));

  static KIPriorityThread? _instance;

  static KIPriorityThread get instance {
    _instance ??= KIPriorityThread._();
    return _instance!;
  }

  static int _taskSorter(_TaskEntry e1, _TaskEntry e2) {
    return -e1.priority.compareTo(e2.priority);
  }

  Future<R> scheduleTask<Q, R>(KIThreadCallback<Q, R> task, Q value, int priority, ValueGetter<bool> runnable) {
    return _scheduleTask<Q, R>(task, value, priority, runnable);
  }
}

class KIThread extends _KIThread {
  KIThread._() : super(KIListQueue<_TaskEntry>());

  static KIThread? _instance;

  static KIThread get instance {
    _instance ??= KIThread._();
    return _instance!;
  }

  Future<R> scheduleTask<Q, R>(KIThreadCallback<Q, R> task, Q value, ValueGetter<bool> runnable) {
    return _scheduleTask<Q, R>(task, value, 0, runnable);
  }
}

class _KIThread {
  _KIThread(this._taskQueue);

  static _run(SendPort sender) async {
    var receiver = ReceivePort();
    sender.send(receiver.sendPort);

    await for (final m in receiver) {
      if (m is List) {
        var task = m[0];
        var value = m[1];
        var back = m[2] as SendPort;
        back.send(task(value));
      } else if (m == null) {
        break;
      }
    }
    Isolate.exit();
  }

  int _maxActive = 3;

  int get maxActive => _maxActive;

  set maxActive(int v) {
    if (v == _maxActive || v < 0) {
      return;
    }

    var remain = v - _maxActive;
    _maxActive = v;

    if (remain > 0) {
      // 扩容
      for (var i = 0; i < remain; i++) {
        _ensureEventLoopCallback();
      }
    } else {
      // 缩容
      for (var i = remain; i < 0; i++) {
        if (_senders.isEmpty) {
          break;
        }
        var first = _senders.removeFirst();
        _releaseSender(first);
      }
    }
  }

  int _active = 0;

  final KIQueue<SendPort> _senders = KIListQueue<SendPort>();

  Future<SendPort?> _lazySender() async {
    if (_senders.isNotEmpty) {
      var first = _senders.removeFirst();
      return Future.value(first);
    }

    if (_senders.isEmpty && (_maxActive <= 0 || _maxActive > 0 && _active < _maxActive)) {
      _active++;
      var receiver = ReceivePort();
      await Isolate.spawn(_run, receiver.sendPort);
      SendPort sender = await receiver.first;
      receiver.close();
      return sender;
    }

    return Future.value(null);
  }

  void _releaseSender(SendPort sender) {
    if (_maxActive > 0 && _active > _maxActive) {
      _active--;
      sender.send(null);
      return;
    }
    _senders.add(sender);
  }

  final KIQueue<_TaskEntry> _taskQueue;

  Future<R> _scheduleTask<Q, R>(KIThreadCallback<Q, R> task, Q value, int priority, ValueGetter<bool> runnable) {
    final _TaskEntry<Q, R> entry = _TaskEntry<Q, R>(task, value, priority, runnable);
    _taskQueue.add(entry);
    _ensureEventLoopCallback();
    return entry.completer.future;
  }

  void _ensureEventLoopCallback() {
    if (_taskQueue.isEmpty) {
      return;
    }
    Timer.run(() {
      _removeInvalidTasks();
      _runTasks();
    });
  }

  void _removeInvalidTasks() {
    while (_taskQueue.isNotEmpty) {
      if (_taskQueue.first.runnable()) {
        break;
      }
      _taskQueue.removeFirst();
    }
  }

  void _runTasks() async {
    var sender = await _lazySender();
    if (sender != null) {
      var ok = await _handleEventLoopCallback(sender);
      _releaseSender(sender);
      if (ok) {
        _ensureEventLoopCallback();
      }
    }
  }

  Future<bool> _handleEventLoopCallback(SendPort sender) async {
    if (_taskQueue.isEmpty) {
      return false;
    }
    final _TaskEntry entry = _taskQueue.removeFirst();

    final ReceivePort receiver = ReceivePort();

    try {
      sender.send([entry.task, entry.value, receiver.sendPort]);
      var result = await receiver.first;

      entry.completer.complete(result);
    } catch (exception, exceptionStack) {
      StackTrace? callbackStack;
      assert(() {
        callbackStack = entry.debugStack;
        return true;
      }());
      FlutterError.reportError(FlutterErrorDetails(
        exception: exception,
        stack: exceptionStack,
        library: 'scheduler library',
        context: ErrorDescription('during a task callback'),
        informationCollector: (callbackStack == null)
            ? null
            : () {
                return <DiagnosticsNode>[
                  DiagnosticsStackTrace(
                    '\nThis exception was thrown in the context of a scheduler callback. '
                    'When the scheduler callback was _registered_ (as opposed to when the '
                    'exception was thrown), this was the stack',
                    callbackStack,
                  ),
                ];
              },
      ));
    } finally {
      receiver.close();
    }
    return _taskQueue.isNotEmpty;
  }
}

class _TaskEntry<Q, R> {
  _TaskEntry(this.task, this.value, this.priority, this.runnable) {
    assert(() {
      debugStack = StackTrace.current;
      return true;
    }());
  }

  final dynamic task;
  final Q value;
  final int priority;
  final ValueGetter<bool> runnable;

  late StackTrace debugStack;
  final Completer<R> completer = Completer<R>();
}
