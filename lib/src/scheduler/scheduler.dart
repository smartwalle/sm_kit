import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:sm_kit/src/queue/queue.dart';

typedef KITaskCallback<T> = T Function();

class KIPriorityScheduler extends _KIScheduler {
  KIPriorityScheduler._() : super(KIPriorityQueue<_TaskEntry<dynamic>>(_taskSorter));

  static KIPriorityScheduler? _instance;

  static KIPriorityScheduler get instance {
    _instance ??= KIPriorityScheduler._();
    return _instance!;
  }

  static int _taskSorter(_TaskEntry<dynamic> e1, _TaskEntry<dynamic> e2) {
    return -e1.priority.compareTo(e2.priority);
  }

  Future<T> scheduleTask<T>(KITaskCallback<T> task, int priority, ValueGetter<bool> runnable,
      {String? debugLabel, Flow? flow}) {
    return _scheduleTask<T>(task, priority, runnable, debugLabel: debugLabel, flow: flow);
  }
}

class KIScheduler extends _KIScheduler {
  KIScheduler._() : super(KIListQueue<_TaskEntry<dynamic>>());

  static KIScheduler? _instance;

  static KIScheduler get instance {
    _instance ??= KIScheduler._();
    return _instance!;
  }

  static KIPriorityScheduler get priority => KIPriorityScheduler.instance;

  Future<T> scheduleTask<T>(KITaskCallback<T> task, ValueGetter<bool> runnable, {String? debugLabel, Flow? flow}) {
    return _scheduleTask<T>(task, 0, runnable, debugLabel: debugLabel, flow: flow);
  }
}

/// This is a fork of flutter/scheduler/binding.dart
class _KIScheduler {
  _KIScheduler(this._taskQueue);

  // final SchedulingStrategy _schedulingStrategy = defaultSchedulingStrategy;

  final KIQueue<_TaskEntry<dynamic>> _taskQueue;

  Future<T> _scheduleTask<T>(KITaskCallback<T> task, int priority, ValueGetter<bool> runnable,
      {String? debugLabel, Flow? flow}) {
    // final bool isFirstTask = _taskQueue.isEmpty;
    final _TaskEntry<T> entry = _TaskEntry<T>(task, priority, runnable, debugLabel, flow);
    _taskQueue.add(entry);
    // if (isFirstTask) {
    if (_maxActive > _active) {
      _ensureEventLoopCallback();
    }
    return entry.completer.future;
  }

  // bool _hasRequestedAnEventLoopCallback = false;

  int _maxActive = 1;

  int get maxActive => _maxActive;

  set maxActive(int v) {
    _maxActive = v;
  }

  int _active = 0;

  void _ensureEventLoopCallback() {
    assert(_taskQueue.isNotEmpty);
    // if (_hasRequestedAnEventLoopCallback) {
    if (_active >= _maxActive) {
      return;
    }
    // _hasRequestedAnEventLoopCallback = true;
    _active++;
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
    await SchedulerBinding.instance.endOfFrame;
    // _hasRequestedAnEventLoopCallback = false;
    _active--;
    if (_handleEventLoopCallback()) {
      _ensureEventLoopCallback();
    }
  }

  bool _handleEventLoopCallback() {
    if (_taskQueue.isEmpty) {
      return false;
    }
    final _TaskEntry<dynamic> entry = _taskQueue.first;
    // if (_schedulingStrategy(priority: Priority.animation.value, scheduler: SchedulerBinding.instance)) {
    try {
      _taskQueue.removeFirst();
      entry.run();
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
    }
    return _taskQueue.isNotEmpty;
    // }
    // return false;
  }
}

class _TaskEntry<T> {
  _TaskEntry(this.task, this.priority, this.runnable, this.debugLabel, this.flow) {
    assert(() {
      debugStack = StackTrace.current;
      return true;
    }());
  }

  final KITaskCallback<T> task;
  final int priority;
  final ValueGetter<bool> runnable;
  final String? debugLabel;
  final Flow? flow;

  late StackTrace debugStack;
  final Completer<T> completer = Completer<T>();

  void run() {
    if (!kReleaseMode) {
      Timeline.timeSync(
        debugLabel ?? 'Scheduled Task',
        () {
          completer.complete(task());
        },
        flow: flow != null ? Flow.step(flow!.id) : null,
      );
    } else {
      completer.complete(task());
    }
  }
}
