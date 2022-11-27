import 'dart:async';

typedef KINotificationListenerCallback<T> = Function(T);

mixin KINotificationHandler<T> {
  _onNotification(dynamic notification) {
    if (notification is T) {
      onNotification(notification);
    }
  }

  bool _match(dynamic notification) {
    return notification is T;
  }

  void onNotification(T notification);
}

class KINotificationWrapper<T> with KINotificationHandler<T> {
  KINotificationWrapper({
    required this.handler,
  });

  final KINotificationListenerCallback<T> handler;

  @override
  void onNotification(T notification) {
    handler(notification);
  }
}

abstract class KINotificationSubscription {
  void cancel();
}

class _KINotificationSubscription implements KINotificationSubscription {
  _KINotificationSubscription({required this.center, required this.handler});

  final KINotificationCenter center;
  final KINotificationHandler handler;

  @override
  void cancel() {
    center.remove(handler);
  }
}

class KINotificationCenter {
  static KINotificationCenter? _instance;

  static KINotificationCenter get instance {
    _instance ??= KINotificationCenter();
    return _instance!;
  }

  final _streamController = StreamController<dynamic>.broadcast();

  final _handlers = <KINotificationHandler, StreamSubscription>{};

  void dispatch(dynamic notification) async {
    _streamController.add(notification);
  }

  KINotificationSubscription? handle(KINotificationHandler handler) {
    if (_handlers.containsKey(handler)) {
      return null;
    }
    final stream = _streamController.stream.where(handler._match);
    var subscription = stream.listen(handler._onNotification);
    _handlers[handler] = subscription;
    return _KINotificationSubscription(center: this, handler: handler);
  }

  void remove(KINotificationHandler handler) {
    if (!_handlers.containsKey(handler)) {
      return;
    }
    var subscription = _handlers.remove(handler);
    subscription?.cancel();
  }

  void removeAll() {
    _handlers.forEach((key, value) {
      value.cancel();
    });
    _handlers.clear();
  }
}
