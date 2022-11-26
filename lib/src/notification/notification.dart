import 'dart:async';

typedef KINotificationListenerCallback<T> = Function(T);

class KINotificationListener<T> {
  KINotificationListener({
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

  final _listeners = <KINotificationListener, StreamSubscription>{};

  void dispatch(dynamic notification) async {
    _streamController.add(notification);
  }

  void handle(KINotificationListener listener) {
    if (_listeners.containsKey(listener)) {
      return;
    }
    final stream = _streamController.stream.where(listener._match);
    var subscription = stream.listen(listener._onNotification);
    _listeners[listener] = subscription;
  }

  void remove(KINotificationListener listener) {
    if (!_listeners.containsKey(listener)) {
      return;
    }
    var subscription = _listeners.remove(listener);
    subscription?.cancel();
  }

  void removeAll() {
    _listeners.forEach((key, value) {
      value.cancel();
    });
    _listeners.clear();
  }
}
