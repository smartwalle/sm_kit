import 'package:flutter/material.dart';

class KIStateView extends StatefulWidget {
  const KIStateView({
    Key? key,
    required this.states,
    required this.controller,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.linear,
    this.onStateChanged,
  }) : super(key: key);

  final List<KIViewState> states;
  final KIViewStateController controller;

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
    _controller.addStatusListener((status) {
      widget.controller._animationStatus = status;
    });
    _controller.forward(from: 1);

    widget.controller.state.addListener(() {
      _controller.forward(from: 0);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.controller.state,
      builder: (context, value, child) {
        KIViewState nState;
        if (value.isEmpty) {
          nState = widget.states.first;
        } else {
          nState = widget.states.firstWhere((element) => element.name == value);
        }
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
            widget.onStateChanged?.call(value);
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
      },
    );
  }
}

class KIViewStateController {
  KIViewStateController(String stateName) : _state = ValueNotifier(stateName);

  final ValueNotifier<String> _state;

  ValueNotifier<String> get state => _state;

  String get stateName => _state.value;

  void updateState(String stateName) => _state.value = stateName;

  late AnimationStatus _animationStatus = AnimationStatus.completed;

  AnimationStatus get animationStatus => _animationStatus;
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
}
