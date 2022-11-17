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

  static _run(SendPort send) async {
    var receive = ReceivePort();
    send.send(receive.sendPort);
    receive.listen((message) {
      if (message is List) {
        var task = message[0];
        var back = message[2] as SendPort;
        back.send(task(message[1]));
      }
    });
  }

  SendPort? _sender;

  Future<SendPort> _lazySender() async {
    if (_sender == null) {
      var receive = ReceivePort();
      await Isolate.spawn(_run, receive.sendPort);
      _sender = await receive.first;
    }
    return Future.value(_sender);
  }

  final KIQueue<_TaskEntry> _taskQueue;

  Future<R> _scheduleTask<Q, R>(KIThreadCallback<Q, R> task, Q value, int priority, ValueGetter<bool> runnable) {
    final bool isFirstTask = _taskQueue.isEmpty;
    final _TaskEntry<Q, R> entry = _TaskEntry<Q, R>(task, value, priority, runnable);
    _taskQueue.add(entry);
    if (isFirstTask) {
      _ensureEventLoopCallback();
    }
    return entry.completer.future;
  }

  bool _hasRequestedAnEventLoopCallback = false;

  void _ensureEventLoopCallback() {
    assert(_taskQueue.isNotEmpty);
    if (_hasRequestedAnEventLoopCallback) {
      return;
    }
    _hasRequestedAnEventLoopCallback = true;
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
    _hasRequestedAnEventLoopCallback = false;
    if (await _handleEventLoopCallback()) {
      _ensureEventLoopCallback();
    }
  }

  Future<bool> _handleEventLoopCallback() async {
    if (_taskQueue.isEmpty) {
      return false;
    }
    final _TaskEntry entry = _taskQueue.first;

    final ReceivePort receiver = ReceivePort();

    try {
      _taskQueue.removeFirst();
      var sender = await _lazySender();
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
