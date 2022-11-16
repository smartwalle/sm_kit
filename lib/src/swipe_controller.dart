import 'package:flutter/widgets.dart';

enum KISwipeBehavior {
  topToBottom,
  bottomToTop,
  leftToRight,
  rightToLeft,
}

class KISwipeController {
  KISwipeController(
    TickerProvider vsync,
    VoidCallback onSwipeComplete, {
    this.behavior = KISwipeBehavior.topToBottom,
    this.threshold = 150,
  }) {
    _controller = AnimationController(vsync: vsync);
    _controller.addListener(_handleSwipeAnimation);
    _onSwipeComplete = onSwipeComplete;
  }

  late final AnimationController _controller;

  late final VoidCallback _onSwipeComplete;

  final KISwipeBehavior behavior;

  final _value = ValueNotifier<double>(0);

  double get value => _value.value;

  final _tapDown = ValueNotifier<bool>(false);

  final double threshold;

  void dispose() {
    _controller.dispose();
  }

  void _handleSwipeAnimation() {
    _value.value = _controller.value;
  }

  void _handleTapDown(TapDownDetails details) {
    _tapDown.value = true;
  }

  void _handleTapUp(TapUpDetails details) {
    _tapDown.value = false;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating) {
      _controller.stop();
    }

    _tapDown.value = true;

    double delta = 0;
    switch (behavior) {
      case KISwipeBehavior.topToBottom:
        delta = details.delta.dy * -1;
        break;
      case KISwipeBehavior.bottomToTop:
        delta = details.delta.dy;
        break;
      case KISwipeBehavior.leftToRight:
        delta = details.delta.dx * -1;
        break;
      case KISwipeBehavior.rightToLeft:
        delta = details.delta.dx;
        break;
    }

    double value = (_value.value - delta / threshold).clamp(0, 1);
    if (value != _value.value) {
      _value.value = value;
      if (_value.value == 1) {
        _onSwipeComplete();
      }
    }
  }

  void _handleDragEnd(DragEndDetails? details) {
    _verticalDragCancel();
  }

  void _handleDragCancel() {
    _verticalDragCancel();
  }

  void _verticalDragCancel() {
    _controller.duration = Duration(microseconds: (_value.value * 1000 * 1000).round()) * 0.5;
    _controller.reverse(from: _value.value);
    _tapDown.value = false;
  }

  Widget wrapGestureDetector({Key? key, required Widget child}) {
    return GestureDetector(
      key: key,
      excludeFromSemantics: true,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      onVerticalDragCancel: _handleDragCancel,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      onHorizontalDragCancel: _handleDragCancel,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }

  Widget buildListener({required Widget Function(double value, bool isTapDown, Widget? child) builder, Widget? child}) {
    return ValueListenableBuilder<double>(
      valueListenable: _value,
      builder: (_, value, __) => ValueListenableBuilder<bool>(
        valueListenable: _tapDown,
        builder: (_, isTapDown, __) {
          return builder(value, isTapDown, child);
        },
      ),
    );
  }
}
