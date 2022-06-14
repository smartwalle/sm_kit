import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class KIAnimatedButton extends ImplicitlyAnimatedWidget {
  KIAnimatedButton({
    Key? key,
    required this.onPressed,
    this.onLongPress,
    this.onHighlightChanged,
    this.mouseCursor,

    // 支持动画属性开始
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
    Decoration? decoration,
    // 支持动画属性结束

    this.visualDensity = VisualDensity.standard,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    MaterialTapTargetSize? materialTapTargetSize,
    this.child,
    this.enableFeedback = true,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  })  : materialTapTargetSize =
            materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
        assert(elevation >= 0.0),
        assert(focusElevation >= 0.0),
        assert(hoverElevation >= 0.0),
        assert(highlightElevation >= 0.0),
        assert(disabledElevation >= 0.0),
        constraints = (size != null
            ? BoxConstraints(minWidth: size.width, minHeight: size.height)
            : const BoxConstraints(minWidth: 88.0, minHeight: 36.0)),
        decoration =
            decoration ?? const BoxDecoration(color: Colors.transparent),
        super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHighlightChanged;
  final MouseCursor? mouseCursor;

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

  final ShapeBorder shape = const RoundedRectangleBorder();
  final VisualDensity visualDensity;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;
  final MaterialTapTargetSize materialTapTargetSize;

  final Widget? child;
  final bool enableFeedback;

  bool get enabled => onPressed != null || onLongPress != null;

  @override
  AnimatedWidgetBaseState<KIAnimatedButton> createState() =>
      _KIStateButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>("textStyle", textStyle,
        defaultValue: null));

    properties.add(
        DiagnosticsProperty<Color>("fillColor", fillColor, defaultValue: null));
    properties.add(DiagnosticsProperty<Color>("focusColor", focusColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>("hoverColor", hoverColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>("highlightColor", highlightColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>("splashColor", splashColor,
        defaultValue: null));

    properties.add(DiagnosticsProperty<double>("elevation", elevation,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>("hoverElevation", hoverElevation,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>("focusElevation", focusElevation,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        "highlightElevation", highlightElevation,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        "disabledElevation", disabledElevation,
        defaultValue: null));

    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<BoxConstraints>(
        'constraints', constraints,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Decoration>('decoration', decoration,
        defaultValue: null));
  }
}

class _KIStateButtonState extends AnimatedWidgetBaseState<KIAnimatedButton> {
  TextStyleTween? _textStyle;

  ColorTween? _fillColor;
  ColorTween? _focusColor;
  ColorTween? _hoverColor;
  ColorTween? _highlightColor;
  ColorTween? _splashColor;

  Tween<double>? _elevation;
  Tween<double>? _focusElevation;
  Tween<double>? _hoverElevation;
  Tween<double>? _highlightElevation;
  Tween<double>? _disabledElevation;

  EdgeInsetsGeometryTween? _padding;
  BoxConstraintsTween? _constraints;
  DecorationTween? _decoration;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.animation;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: _decoration?.evaluate(animation),
      child: RawMaterialButton(
        onPressed: widget.onPressed,
        onLongPress: widget.onLongPress,
        onHighlightChanged: widget.onHighlightChanged,
        mouseCursor: widget.mouseCursor,
        textStyle: _textStyle?.evaluate(animation),
        fillColor: _fillColor?.evaluate(animation),
        focusColor: _focusColor?.evaluate(animation),
        hoverColor: _hoverColor?.evaluate(animation),
        highlightColor: _highlightColor?.evaluate(animation),
        splashColor: _splashColor?.evaluate(animation),
        elevation: _elevation!.evaluate(animation),
        focusElevation: _focusElevation!.evaluate(animation),
        hoverElevation: _hoverElevation!.evaluate(animation),
        highlightElevation: _highlightElevation!.evaluate(animation),
        disabledElevation: _disabledElevation!.evaluate(animation),
        padding: _padding!.evaluate(animation),
        constraints: _constraints!.evaluate(animation),
        shape: widget.shape,
        visualDensity: widget.visualDensity,
        animationDuration: kThemeAnimationDuration,
        clipBehavior: widget.clipBehavior,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        materialTapTargetSize: widget.materialTapTargetSize,
        enableFeedback: widget.enableFeedback,
        child: widget.child,
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _textStyle = visitor(
      _textStyle,
      widget.textStyle,
      (dynamic value) => TextStyleTween(begin: value as TextStyle),
    ) as TextStyleTween?;
    _fillColor = visitor(
      _fillColor,
      widget.fillColor,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
    _focusColor = visitor(_focusColor, widget.focusColor,
        (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
    _hoverColor = visitor(
      _hoverColor,
      widget.hoverColor,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
    _highlightColor = visitor(
      _highlightColor,
      widget.highlightColor,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
    _splashColor = visitor(
      _splashColor,
      widget.splashColor,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
    _elevation = visitor(
      _elevation,
      widget.elevation,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _focusElevation = visitor(
      _focusElevation,
      widget.focusElevation,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _hoverElevation = visitor(
      _hoverElevation,
      widget.hoverElevation,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _highlightElevation = visitor(
      _highlightElevation,
      widget.highlightElevation,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _disabledElevation = visitor(
      _disabledElevation,
      widget.disabledElevation,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _padding = visitor(
      _padding,
      widget.padding,
      (dynamic value) =>
          EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry),
    ) as EdgeInsetsGeometryTween?;
    _constraints = visitor(
      _constraints,
      widget.constraints,
      (dynamic value) => BoxConstraintsTween(begin: value as BoxConstraints),
    ) as BoxConstraintsTween?;
    _decoration = visitor(
      _decoration,
      widget.decoration,
      (dynamic value) => DecorationTween(begin: value as Decoration),
    ) as DecorationTween?;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<TextStyleTween>('textStyle', _textStyle,
        defaultValue: null));

    description.add(DiagnosticsProperty<ColorTween>('fillColor', _fillColor,
        defaultValue: null));
    description.add(DiagnosticsProperty<ColorTween>('focusColor', _focusColor,
        defaultValue: null));
    description.add(DiagnosticsProperty<ColorTween>('hoverColor', _hoverColor,
        defaultValue: null));
    description.add(DiagnosticsProperty<ColorTween>(
        'highlightColor', _highlightColor,
        defaultValue: null));
    description.add(DiagnosticsProperty<ColorTween>('splashColor', _splashColor,
        defaultValue: null));

    description.add(DiagnosticsProperty<Tween<double>>('elevation', _elevation,
        defaultValue: null));
    description.add(DiagnosticsProperty<Tween<double>>(
        'focusElevation', _focusElevation,
        defaultValue: null));
    description.add(DiagnosticsProperty<Tween<double>>(
        'hoverElevation', _hoverElevation,
        defaultValue: null));
    description.add(DiagnosticsProperty<Tween<double>>(
        'highlightElevation', _highlightElevation,
        defaultValue: null));
    description.add(DiagnosticsProperty<Tween<double>>(
        'disabledElevation', _disabledElevation,
        defaultValue: null));

    description.add(DiagnosticsProperty<EdgeInsetsGeometryTween>(
        'padding', _padding,
        defaultValue: null));
    description.add(DiagnosticsProperty<BoxConstraintsTween>(
        'constraints', _constraints,
        defaultValue: null));
    description.add(DiagnosticsProperty<DecorationTween>(
        'decoration', _decoration,
        defaultValue: null));
  }
}
