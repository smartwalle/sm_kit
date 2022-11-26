import 'dart:async';

typedef KINotificationListenerCallback<T> = Function(T);

class KINotificationHandler<T> {
  KINotificationHandler({
    required this.onNotification,
  });

  _onNotification(dynamic notification) {
    if (notification is T) {
      onNotification(notification);
    }
  }

  bool _match(dynamic notification) {
    return notification is T;
  }

  KINotificationListenerCallback<T> onNotification;
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

  void handle(KINotificationHandler handler) {
    if (_handlers.containsKey(handler)) {
      return;
    }
    final stream = _streamController.stream.where(handler._match);
    var subscription = stream.listen(handler._onNotification);
    _handlers[handler] = subscription;
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
