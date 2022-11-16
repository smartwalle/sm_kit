import 'package:flutter/material.dart';

enum KISwipeDirection {
  ltr,
  rtl,
}

enum KISwipeViewStatus {
  dismissed,
  completed,
}

typedef KISwipeViewBuilder = Widget Function(KISwipeViewController controller, Animation<double> animation);
typedef KISwipeViewStatusChanged = void Function(KISwipeViewController controller);

abstract class KISwipeViewController {
  open();

  close();

  double get backgroundWidth;

  KISwipeViewStatus get status;
}

class KISwipeView extends StatelessWidget {
  KISwipeView({
    Key? key,
    required this.foreground,
    required this.background,
    this.onDragStart,
    this.onStatusChanged,
    this.direction = KISwipeDirection.rtl,
    this.backgroundWidth,
    double? backgroundRatio,
    this.duration = const Duration(milliseconds: 400),
  }) : super(key: key) {
    assert(backgroundWidth == null || backgroundRatio == null, '不能同时设置 backgroundWidth 和 backgroundRatio.');
    assert(
        backgroundRatio == null || backgroundRatio > 0 && backgroundRatio < 1.0, '参数 backgroundRatio 的取值范围为 (0, 1).');

    this.backgroundRatio = backgroundWidth == null ? (backgroundRatio ?? 0.3) : null;
  }

  final KISwipeViewBuilder foreground;
  final KISwipeViewBuilder background;

  final KISwipeViewStatusChanged? onDragStart;
  final KISwipeViewStatusChanged? onStatusChanged;

  final KISwipeDirection direction;

  /// backgroundWidth 和 backgroundRatio 都是用于设置 background 的可视宽度，同时只会有一个值生效
  /// backgroundWidth 是设置一个精确值
  /// backgroundRatio 是设置一个比例，background 的可视宽度会根据父 Widget 的实际宽度进行动态调整
  final double? backgroundWidth;
  late final double? backgroundRatio;

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return _KISwipeView(
        foreground: foreground,
        background: background,
        onDragStart: onDragStart,
        onStatusChanged: onStatusChanged,
        direction: direction,
        width: constraints.biggest.width,
        backgroundWidth: backgroundWidth,
        backgroundRatio: backgroundRatio,
        duration: duration,
      );
    });
  }
}

class _KISwipeView extends StatefulWidget {
  const _KISwipeView({
    Key? key,
    required this.foreground,
    required this.background,
    this.onDragStart,
    this.onStatusChanged,
    required this.direction,
    required this.width,
    this.backgroundRatio,
    this.backgroundWidth,
    required this.duration,
  }) : super(key: key);

  final KISwipeViewBuilder foreground;
  final KISwipeViewBuilder background;

  final KISwipeViewStatusChanged? onDragStart;
  final KISwipeViewStatusChanged? onStatusChanged;

  final KISwipeDirection direction;

  final double width;

  final double? backgroundWidth;
  final double? backgroundRatio;

  final Duration duration;

  @override
  State<_KISwipeView> createState() => _KISwipeViewState();
}

class _KISwipeViewState extends State<_KISwipeView> with SingleTickerProviderStateMixin, KISwipeViewController {
  late AnimationController controller;
  late Animation<double> offsetAnimation;

  late KISwipeViewStatus _status;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration, value: 0);
    controller.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.dismissed:
          _status = KISwipeViewStatus.dismissed;
          break;
        case AnimationStatus.completed:
          _status = KISwipeViewStatus.completed;
          break;
      }

      widget.onStatusChanged?.call(this);
    });
    _status = KISwipeViewStatus.dismissed;
    _rebuildOffsetAnimation();
  }

  @override
  void didUpdateWidget(_KISwipeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _rebuildOffsetAnimation();
  }

  void _rebuildOffsetAnimation() {
    offsetAnimation = Tween<double>(begin: 0, end: backgroundWidth).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int get direction => widget.direction == KISwipeDirection.ltr ? 1 : -1;

  @override
  Widget build(BuildContext context) {
    var left = widget.direction == KISwipeDirection.ltr ? 0.0 : widget.width - backgroundWidth;
    var right = widget.direction == KISwipeDirection.rtl ? 0.0 : widget.width - backgroundWidth;

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          left: left,
          right: right,
          child: widget.background(this, controller),
        ),
        GestureDetector(
          onHorizontalDragStart: (details) {
            widget.onDragStart?.call(this);
          },
          onHorizontalDragUpdate: (details) {
            final primaryDelta = (details.primaryDelta ?? 0) * direction;
            if (primaryDelta > 20) {
              return;
            }
            controller.value += primaryDelta / backgroundWidth;
          },
          onHorizontalDragEnd: (details) {
            var primaryVelocity = (details.primaryVelocity ?? 0) * direction;
            if (primaryVelocity > 1500) {
              controller.forward();
            } else if (primaryVelocity < -1500) {
              controller.reverse();
            } else {
              if (controller.value > 0.5) {
                controller.forward();
              } else {
                controller.reverse();
              }
            }
          },
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(offsetAnimation.value * direction, 0),
                child: child,
              );
            },
            child: widget.foreground(this, controller),
          ),
        ),
      ],
    );
  }

  @override
  close() {
    if (mounted) {
      controller.reverse();
    }
  }

  @override
  open() {
    if (mounted) {
      controller.forward();
    }
  }

  @override
  double get backgroundWidth => widget.backgroundWidth ?? widget.backgroundRatio! * widget.width;

  @override
  KISwipeViewStatus get status => _status;
}
