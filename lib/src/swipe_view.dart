import 'package:flutter/material.dart';

enum KISwipeDirection {
  ltr,
  rtl,
}

typedef KISwipeViewBuilder = Widget Function(KISwipeViewController controller);

abstract class KISwipeViewController {
  open();

  close();
}

class KISwipeView extends StatefulWidget {
  const KISwipeView({
    Key? key,
    required this.front,
    required this.back,
    this.direction = KISwipeDirection.rtl,
    this.end = 0.3,
    this.duration = const Duration(milliseconds: 400),
  })  : assert(end > 0 && end < 1.0, '参数 end 的取值范围为 (0, 1).'),
        super(key: key);

  final KISwipeViewBuilder front;
  final KISwipeViewBuilder back;

  final KISwipeDirection direction;

  final double end;

  final Duration duration;

  @override
  State<KISwipeView> createState() => _KISwipeViewState();
}

class _KISwipeViewState extends State<KISwipeView> with SingleTickerProviderStateMixin, KISwipeViewController {
  late AnimationController controller;
  late Animation<double> offsetAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: widget.duration, value: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    offsetAnimation = Tween<double>(begin: 0, end: MediaQuery.of(context).size.width * widget.end).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int get _direction => widget.direction == KISwipeDirection.ltr ? 1 : -1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        widget.back(this),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            final primaryDelta = (details.primaryDelta ?? 0) * _direction;
            controller.value += primaryDelta / (MediaQuery.of(context).size.width * widget.end);
          },
          onHorizontalDragEnd: (details) {
            var primaryVelocity = (details.primaryVelocity ?? 0) * _direction;
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
                offset: Offset(offsetAnimation.value * _direction, 0),
                child: widget.front(this),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  close() {
    controller.reverse();
  }

  @override
  open() {
    controller.forward();
  }
}
