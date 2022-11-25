abstract class KINotification {}

typedef KINotificationListenerCallback<T> = Function(T);

class KINotificationListener<T extends KINotification> {
  KINotificationListener({
    required this.onNotification,
  });

  _onNotification(KINotification notification) {
    if (notification is T) {
      onNotification(notification);
    }
  }

  final KINotificationListenerCallback onNotification;
}

class KINotificationCenter {
  static KINotificationCenter? _instance;

  static KINotificationCenter get instance {
    _instance ??= KINotificationCenter();
    return _instance!;
  }

  final _listeners = <KINotificationListener>[];

  void dispatch(KINotification notification) async {
    for (var listener in _listeners) {
      listener._onNotification(notification);
    }
  }

  void handle(KINotificationListener listener) {
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void remove(KINotificationListener listener) {
    if (!_listeners.contains(listener)) {
      return;
    }
    _listeners.remove(listener);
  }

  void removeAll() {
    _listeners.clear();
  }
}
