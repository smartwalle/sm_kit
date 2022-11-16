import 'package:flutter/material.dart';
import 'package:sm_kit/src/animated_button.dart';
import 'package:sm_kit/src/state_controller.dart';
import 'package:sm_kit/src/state_delegate.dart';

class KIStateButton extends StatefulWidget {
  KIStateButton({
    Key? key,
    this.state,
    this.controller,
    required List<KIStateButtonState> states,
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
  })  : assert(state != null || controller != null, '需要设置 state 或者 controller.'),
        assert(state == null || controller == null, '不能同时设置 state 和 controller.'),
        delegate = KIStateListDelegate(states),
        super(key: key);

  KIStateButton.builder({
    Key? key,
    this.state,
    this.controller,
    required KIStateBuilder<KIStateButtonState> stateBuilder,
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
  })  : assert(state != null || controller != null, '需要设置 state 或者 controller.'),
        assert(state == null || controller == null, '不能同时设置 state 和 controller.'),
        delegate = KIStateBuilderDelegate(stateBuilder),
        super(key: key);

  final String? state;
  final KIStateController? controller;

  final KIStateDelegate<KIStateButtonState> delegate;

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

class _KIStateButtonState extends State<KIStateButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  late KIStateController? _stateController;

  KIStateController get stateController => widget.controller ?? _stateController!;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _controller.addStatusListener((status) {
      setState(() {});
    });

    if (widget.controller == null) {
      _stateController = KIStateController(widget.state!);
    }
    stateController.addListener(_didStateChanged);

    _controller.forward(from: 1);
    super.initState();
  }

  @override
  void didUpdateWidget(KIStateButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null && oldWidget.controller != null) {
      oldWidget.controller?.removeListener(_didStateChanged);
      _stateController = KIStateController(widget.state!);
      _stateController?.addListener(_didStateChanged);
    } else if (widget.controller != null && oldWidget.controller == null) {
      _stateController?.dispose();
      _stateController = null;
      widget.controller?.addListener(_didStateChanged);
    } else if (widget.controller != null && oldWidget.controller != null) {
      if (widget.controller != oldWidget.controller) {
        oldWidget.controller?.removeListener(_didStateChanged);
        widget.controller?.addListener(_didStateChanged);
      }
    } else if (widget.controller == null && oldWidget.controller == null) {
      if (_stateController == null) {
        _stateController = KIStateController(widget.state!);
        _stateController?.addListener(_didStateChanged);
      } else {
        _stateController?.state = widget.state!;
      }
    }
  }

  void _didStateChanged() {
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    stateController.removeListener(_didStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    KIStateButtonState nState = widget.delegate.build(stateController.state);
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
      onPressed: _controller.status == AnimationStatus.completed ? nState.onPressed : null,
      onLongPress: _controller.status == AnimationStatus.completed ? nState.onLongPress : null,
      onHighlightChanged: _controller.status == AnimationStatus.completed ? nState.onHighlightChanged : null,
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

class KIStateButtonState {
  KIStateButtonState(
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

  @override
  bool operator ==(other) {
    if (other is KIStateButtonState) {
      return name == other.name;
    } else if (other is String) {
      return name == other;
    }
    return false;
  }
}
