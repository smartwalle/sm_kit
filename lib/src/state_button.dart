import 'package:flutter/material.dart';
import 'package:sm_kit/src/animated_button.dart';
import 'package:sm_kit/src/state_controller.dart';

class KIStateButton extends StatefulWidget {
  const KIStateButton({
    Key? key,
    required this.states,
    required this.controller,
    required this.onPressed,
    this.onLongPress,
    this.onHighlightChanged,
    this.mouseCursor,
    this.visualDensity = VisualDensity.standard,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize = MaterialTapTargetSize.padded,
    this.enableFeedback = true,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 500),
    this.onStateChanged,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHighlightChanged;
  final MouseCursor? mouseCursor;

  final List<KIButtonState> states;
  final KIStateController controller;

  final ShapeBorder shape = const RoundedRectangleBorder();
  final VisualDensity visualDensity;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;
  final MaterialTapTargetSize materialTapTargetSize;

  final bool enableFeedback;
  final Duration duration;
  final Curve curve;

  final ValueChanged<String>? onStateChanged;

  @override
  State<KIStateButton> createState() => _KIStateButtonState();
}

class _KIStateButtonState extends State<KIStateButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _controller.addStatusListener((status) {
      widget.controller.updateAnimationStatus(status);
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
        KIButtonState nState;
        if (value.isEmpty) {
          nState = widget.states.first;
        } else {
          nState = widget.states.firstWhere((element) => element.name == value);
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
          constraints: nState.constraints,
          decoration: nState.decoration,
          onPressed: widget.onPressed,
          onLongPress: widget.onLongPress,
          onHighlightChanged: widget.onHighlightChanged,
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
            widget.onStateChanged?.call(value);
          },
          child: FadeTransition(
            opacity: _animation,
            child: nState.child,
          ),
        );
      },
    );
  }
}

class KIButtonState {
  KIButtonState(
    this.name, {
    required this.child,
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
    Size? size,
    BoxConstraints? constraints,
    this.decoration,
  }) : constraints = constraints ??
            (size != null ? BoxConstraints.tight(size) : const BoxConstraints(minWidth: 88.0, minHeight: 36.0));

  final String name;

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

  final BoxConstraints constraints;

  final Decoration? decoration;

  final Widget child;
}
