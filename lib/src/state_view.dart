import 'package:flutter/material.dart';
import 'package:sm_kit/src/state_delegate.dart';

class KIStateView extends StatefulWidget {
  KIStateView({
    Key? key,
    required this.state,
    required List<KIViewState> states,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 500),
    this.onStateChanged,
  })  : delegate = KIStateListDelegate(states),
        super(key: key);

  KIStateView.builder({
    Key? key,
    required this.state,
    required KIStateBuilder<KIViewState> stateBuilder,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 500),
    this.onStateChanged,
  })  : delegate = KIStateBuilderDelegate(stateBuilder),
        super(key: key);

  final String state;
  final KIStateDelegate<KIViewState> delegate;

  final Duration duration;
  final Curve curve;

  final ValueChanged<String>? onStateChanged;

  @override
  State<KIStateView> createState() => _KIStateViewState();
}

class _KIStateViewState extends State<KIStateView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _controller.forward(from: 1);
    super.initState();
  }

  @override
  void didUpdateWidget(KIStateView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.state != widget.state) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    KIViewState nState = widget.delegate.build(widget.state);
    return AnimatedContainer(
      alignment: nState.alignment,
      padding: nState.padding,
      color: nState.decoration == null ? nState.color : null,
      decoration: nState.decoration,
      foregroundDecoration: nState.foregroundDecoration,
      width: nState.size?.width,
      height: nState.size?.height,
      constraints: nState.constraints,
      margin: nState.margin,
      transform: nState.transform,
      transformAlignment: nState.transformAlignment,
      clipBehavior: nState.clipBehavior,
      curve: widget.curve,
      duration: widget.duration,
      onEnd: () {
        widget.onStateChanged?.call(nState.name);
      },
      child: AnimatedDefaultTextStyle(
        duration: widget.duration,
        curve: widget.curve,
        style: nState.textStyle,
        child: FadeTransition(
          opacity: _animation,
          child: nState.child,
        ),
      ),
    );
  }
}

class KIViewState {
  const KIViewState(
    this.name, {
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.color = Colors.white,
    this.decoration,
    this.foregroundDecoration,
    this.size,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.textStyle = const TextStyle(fontSize: 12),
    required this.child,
  });

  final String name;

  final AlignmentGeometry alignment;

  final EdgeInsetsGeometry? padding;

  final Color color;

  final Decoration? decoration;

  final Decoration? foregroundDecoration;

  final Size? size;

  final BoxConstraints? constraints;

  final EdgeInsetsGeometry? margin;

  final Matrix4? transform;

  final AlignmentGeometry? transformAlignment;

  final Clip clipBehavior;

  final TextStyle textStyle;

  final Widget child;

  @override
  bool operator ==(other) {
    if (other is KIViewState) {
      return name == other.name;
    } else if (other is String) {
      return name == other;
    }
    return false;
  }
}
