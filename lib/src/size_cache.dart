import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class _KISizeNotification extends Notification {
  _KISizeNotification(this.id, this.size);

  final int id;
  final Size size;
}

class KISizeNotifier extends SingleChildRenderObjectWidget {
  const KISizeNotifier({
    Key? key,
    required this.id,
    required Widget child,
  }) : super(key: key, child: child);

  final int id;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _KISizeRenderProxyBox(onLayoutChanged: (size) {
      _KISizeNotification(id, size).dispatch(context);
    });
  }
}

class _KISizeRenderProxyBox extends RenderProxyBox {
  _KISizeRenderProxyBox({
    RenderBox? child,
    required this.onLayoutChanged,
  }) : super(child);

  final Function(Size size) onLayoutChanged;

  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    if (_oldSize != size) {
      onLayoutChanged(size);
    }
    _oldSize = size;
  }
}

class KICacheSizeManager extends StatefulWidget {
  const KICacheSizeManager({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<KICacheSizeManager> createState() => _KICacheSizeManagerState();
}

class _KICacheSizeManagerState extends State<KICacheSizeManager> {
  final KICacheSize _cacheSize = KICacheSize();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<_KISizeNotification>(
      onNotification: (notification) {
        _cacheSize.update(notification.id, notification.size);
        return true;
      },
      child: widget.child,
    );
  }
}

class KICacheSize extends ChangeNotifier {
  static KICacheSize? of(BuildContext context) {
    return context.findAncestorStateOfType<_KICacheSizeManagerState>()?._cacheSize;
  }

  final Map<int, Size> _sizes = <int, Size>{};

  void update(int id, Size size) {
    _sizes[id] = size;
  }

  Size? get(int id) {
    return _sizes[id];
  }
}

class KICacheSizeWidget extends StatelessWidget {
  const KICacheSizeWidget({Key? key, required this.id, required this.child}) : super(key: key);

  final int id;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget widget = KISizeNotifier(id: id, child: child);
    var cache = KICacheSize.of(context);
    if (cache != null) {
      var size = cache.get(id);
      if (size != null) {
        widget = SizedBox(width: size.width, height: size.height, child: widget);
      }
    }
    return widget;
  }
}
