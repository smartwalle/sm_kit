import 'dart:async';

mixin KINotificationObserver<T> {
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

class KINotificationHandler<T> with KINotificationObserver<T> {
  KINotificationHandler({
    required this.handler,
  });

  final Function(T) handler;

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
  final KINotificationObserver handler;

  @override
  void cancel() {
    center.removeObserver(handler);
  }
}

class KINotificationCenter {
  static KINotificationCenter? _instance;

  static KINotificationCenter get instance {
    _instance ??= KINotificationCenter();
    return _instance!;
  }

  final _streamController = StreamController<dynamic>.broadcast();

  final _observers = <KINotificationObserver, StreamSubscription>{};

  void dispatch(dynamic notification) async {
    _streamController.add(notification);
  }

  KINotificationSubscription? addObserver(KINotificationObserver observer) {
    if (_observers.containsKey(observer)) {
      return null;
    }
    final stream = _streamController.stream.where(observer._match);
    var subscription = stream.listen(observer._onNotification);
    _observers[observer] = subscription;
    return _KINotificationSubscription(center: this, handler: observer);
  }

  void removeObserver(KINotificationObserver observer) {
    if (!_observers.containsKey(observer)) {
      return;
    }
    var subscription = _observers.remove(observer);
    subscription?.cancel();
  }

  void removeAll() {
    _observers.forEach((key, value) {
      value.cancel();
    });
    _observers.clear();
  }
}
