import 'package:flutter/material.dart';
import 'package:sm_kit/sm_kit.dart';
import 'package:sm_kit/src/animated_button.dart';

class KIStateButton extends StatefulWidget {
  const KIStateButton({
    Key? key,
    required this.state,
    required this.states,
    this.mouseCursor,
    this.visualDensity = VisualDensity.standard,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.enableFeedback = true,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 500),
    this.onStateChanged,
  }) : super(key: key);

  final String state;
  final List<KIButtonState> states;

  final MouseCursor? mouseCursor;

  final ShapeBorder shape = const RoundedRectangleBorder();
  final VisualDensity visualDensity;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;
  final MaterialTapTargetSize? materialTapTargetSize;
  final bool enableFeedback;

  final Duration duration;
  final Curve curve;

  final ValueChanged<String>? onStateChanged;

  @override
  State<KIStateButton> createState() => _KIStateButtonState();
}

class _KIStateButtonState extends State<KIStateButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _controller.addStatusListener((status) {
      setState(() {});
    });
    _controller.forward(from: 1);
    super.initState();
  }

  @override
  void didUpdateWidget(KIStateButton oldWidget) {
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
    KIButtonState nState;
    if (widget.state.isEmpty) {
      nState = widget.states.first;
    } else {
      nState =
          widget.states.firstWhere((element) => element.name == widget.state);
    }
    return KIAnimatedButton(
      textStyle: nState.textStyle,
      fillColor: nState.fillColor,
      focusColor: nState.focusColor,
      hoverColor: nState.hoverColor,
      highlightColor: nState.highlightColor,
      splashColor: nState.splashColor,
      elevation: nState.elevation,
      focusElevation: nState.focusElevation,
      hoverElevation: nState.hoverElevation,
      highlightElevation: nState.highlightElevation,
      disabledElevation: nState.disabledElevation,
      padding: nState.padding,
      size: nState.size,
      decoration: nState.decoration,
      onPressed: _controller.status == AnimationStatus.completed
          ? nState.onPressed
          : null,
      onLongPress: _controller.status == AnimationStatus.completed
          ? nState.onLongPress
          : null,
      onHighlightChanged: _controller.status == AnimationStatus.completed
          ? nState.onHighlightChanged
          : null,
      mouseCursor: widget.mouseCursor,
      visualDensity: widget.visualDensity,
      clipBehavior: widget.clipBehavior,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      materialTapTargetSize: widget.materialTapTargetSize,
      enableFeedback: widget.enableFeedback,
      curve: widget.curve,
      duration: widget.duration,
      onEnd: () {
        widget.onStateChanged?.call(nState.name);
      },
      child: FadeTransition(
        opacity: _animation,
        child: nState.child,
      ),
    );
  }
}

class KIButtonState {
  KIButtonState(
    this.name, {
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.onHighlightChanged,
    this.textStyle,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.elevation = 2.0,
    this.focusElevation = 4.0,
    this.hoverElevation = 4.0,
    this.highlightElevation = 8.0,
    this.disabledElevation = 0.0,
    this.padding = EdgeInsets.zero,
    this.size,
    this.decoration,
  });

  final String name;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final ValueChanged<bool>? onHighlightChanged;

  final TextStyle? textStyle;

  final Color? fillColor;

  final Color? focusColor;

  final Color? hoverColor;

  final Color? highlightColor;

  final Color? splashColor;

  final double elevation;

  final double focusElevation;

  final double hoverElevation;

  final double highlightElevation;

  final double disabledElevation;

  final EdgeInsetsGeometry padding;

  final Size? size;

  final Decoration? decoration;

  final Widget child;
}
