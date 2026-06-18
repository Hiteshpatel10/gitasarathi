import 'dart:math';
import 'package:flutter/material.dart';

class LevelAnimatedButton extends StatefulWidget {
  final Widget child;
  final bool isPressed;
  final double? width;
  final double height;
  final Size? minimumSize;
  final Size? maximumSize;
  final double buttonHeight;
  final double borderRadius;
  final Color? buttonColor;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? disabledForegroundColor;
  final Color? disabledBackgroundColor;
  final ButtonTypes buttonType;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final InteractiveInkFeatureFactory? splashFactory;

  const LevelAnimatedButton({
    Key? key,
    this.onPressed,
    this.padding,
    this.width,
    this.height = 50,
    this.minimumSize,
    this.maximumSize,
    this.isPressed = false,
    this.buttonHeight = 4,
    this.borderRadius = 16,
    this.buttonColor,
    this.foregroundColor = Colors.white,
    this.backgroundColor,
    this.disabledForegroundColor,
    this.disabledBackgroundColor,
    this.splashFactory = NoSplash.splashFactory,
    this.buttonType = ButtonTypes.roundedRectangle,
    required this.child,
  }) : super(key: key);

  @override
  State<LevelAnimatedButton> createState() => _LevelAnimatedButtonState();
}

class _LevelAnimatedButtonState extends State<LevelAnimatedButton>
    with SingleTickerProviderStateMixin {
  late bool _isPressed = widget.isPressed;
  static const Duration duration = Duration(milliseconds: 80);

  @override
  Widget build(BuildContext context) {
    bool isDisabled = widget.onPressed == null;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: LevelButton(
        onPressed: !isDisabled ? _handleButtonPress : null,
        padding: widget.padding,
        width: widget.width,
        height: widget.height,
        minimumSize: widget.minimumSize,
        maximumSize: widget.maximumSize,
        isPressed: isDisabled ? true : _isPressed,
        buttonHeight: widget.buttonHeight,
        borderRadius: widget.borderRadius,
        buttonColor: widget.buttonColor,
        foregroundColor: widget.foregroundColor,
        backgroundColor: widget.backgroundColor,
        disabledForegroundColor: widget.disabledForegroundColor,
        disabledBackgroundColor: widget.disabledBackgroundColor,
        splashFactory: widget.splashFactory,
        buttonType: widget.buttonType,
        child: widget.child,
      ),
    );
  }

  Future<void> _handleButtonPress() async {
    setState(() {
      _isPressed = true;

    });
    await Future.delayed(duration, () {
      setState(() {
        _isPressed = false;
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }
}

class LevelButton extends StatelessWidget {
  final ButtonPositions? _buttonPosition;
  final Widget child;
  final bool isPressed;
  final double? width;
  final double height;
  final Size? minimumSize;
  final Size? maximumSize;
  final double buttonHeight;
  final double borderRadius;
  final Color? buttonColor;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? disabledForegroundColor;
  final Color? disabledBackgroundColor;
  final ButtonTypes buttonType;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final InteractiveInkFeatureFactory? splashFactory;

  const LevelButton({
    Key? key,
    ButtonPositions? buttonPosition,
    this.onPressed,
    this.padding,
    this.width,
    this.height = 50,
    this.minimumSize,
    this.maximumSize,
    this.isPressed = false,
    this.buttonHeight = 4,
    this.borderRadius = 16,
    this.buttonColor,
    this.foregroundColor = Colors.white,
    this.backgroundColor,
    this.disabledForegroundColor,
    this.disabledBackgroundColor,
    this.splashFactory = NoSplash.splashFactory,
    this.buttonType = ButtonTypes.roundedRectangle,
    required this.child,
  })  : _buttonPosition = buttonPosition,
        super(key: key);

  int shadeValue(int value, double factor) => max(0, min(value - (value * factor).round(), 255));

  Color shadeColor(Color color, double factor) => Color.fromRGBO(shadeValue(color.red, factor),
      shadeValue(color.green, factor), shadeValue(color.blue, factor), 1);

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final double levelWidth = buttonType == ButtonTypes.circle ? height : width ?? height;
    final double levelBorderRadius = buttonType == ButtonTypes.roundedRectangle
        ? borderRadius > height / 2
        ? height / 2
        : borderRadius
        : buttonType == ButtonTypes.circle
        ? height
        : borderRadius;
    final RoundedRectangleBorder levelShape = RoundedRectangleBorder(
      borderRadius: (_buttonPosition == null)
          ? buttonType == ButtonTypes.oval
          ? BorderRadius.all(
        Radius.elliptical(levelWidth, height),
      )
          : BorderRadius.circular(
        buttonType == ButtonTypes.roundedRectangle
            ? borderRadius - 2
            : levelBorderRadius - 2,
      )
          : (_buttonPosition! == ButtonPositions.start)
          ? buttonType == ButtonTypes.oval
          ? BorderRadius.horizontal(
        left: Radius.elliptical(levelWidth * 2, height),
      )
          : BorderRadius.horizontal(
        left: Radius.circular(
          buttonType == ButtonTypes.roundedRectangle
              ? borderRadius - 2
              : levelBorderRadius - 2,
        ),
      )
          : (_buttonPosition! == ButtonPositions.between)
          ? BorderRadius.zero
          : buttonType == ButtonTypes.oval
          ? BorderRadius.horizontal(
        right: Radius.elliptical(levelWidth * 2, height),
      )
          : BorderRadius.horizontal(
        right: Radius.circular(
          buttonType == ButtonTypes.roundedRectangle
              ? borderRadius - 2
              : levelBorderRadius - 2,
        ),
      ),
    );
    return Container(
        width: levelWidth,
        height: (isPressed || isDisabled) ? height : height + buttonHeight,
        margin: EdgeInsets.only(top: (isPressed || isDisabled) ? buttonHeight : 0),
        padding: EdgeInsets.fromLTRB(
          (_buttonPosition != null && _buttonPosition != ButtonPositions.start) ? 1 : 0,
          0,
          (_buttonPosition != null && _buttonPosition != ButtonPositions.end) ? 1 : 0,
          isPressed || isDisabled ? 0 : buttonHeight,
        ),
        decoration: BoxDecoration(
            color: buttonColor ??
                (backgroundColor != null
                    ? shadeColor(backgroundColor ?? Colors.black, 0.4)
                    : isDisabled
                    ? null
                    : shadeColor(Theme.of(context).colorScheme.primary, 0.4)),
            borderRadius: (_buttonPosition == null)
                ? buttonType == ButtonTypes.oval
                ? BorderRadius.all(Radius.elliptical(levelWidth, height))
                : BorderRadius.circular(levelBorderRadius)
                : (_buttonPosition! == ButtonPositions.start)
                ? buttonType == ButtonTypes.oval
                ? BorderRadius.horizontal(left: Radius.elliptical(levelWidth * 2, height))
                : BorderRadius.horizontal(left: Radius.circular(levelBorderRadius))
                : (_buttonPosition! == ButtonPositions.between)
                ? BorderRadius.zero
                : buttonType == ButtonTypes.oval
                ? BorderRadius.horizontal(
                right: Radius.elliptical(levelWidth * 2, height))
                : BorderRadius.horizontal(right: Radius.circular(levelBorderRadius))),
        child: Theme.of(context).useMaterial3 == true
            ? FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              shape: levelShape,
              minimumSize: minimumSize,
              maximumSize: maximumSize,
              splashFactory: splashFactory,
              foregroundColor: foregroundColor,
              backgroundColor: backgroundColor,
              disabledForegroundColor: disabledForegroundColor,
              disabledBackgroundColor: disabledBackgroundColor,
              padding: (padding != null)
                  ? const EdgeInsets.all(0).add(padding!)
                  : const EdgeInsets.all(0),
            ).copyWith(
                elevation: MaterialStateProperty.all(0),
                overlayColor: MaterialStateProperty.all(splashFactory == NoSplash.splashFactory
                    ? Colors.transparent
                    : Theme.of(context).splashColor)),
            child: child)
            : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                shape: levelShape,
                minimumSize: minimumSize,
                maximumSize: maximumSize,
                splashFactory: splashFactory,
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                disabledForegroundColor: disabledForegroundColor,
                disabledBackgroundColor: disabledBackgroundColor,
                padding: (padding != null)
                    ? const EdgeInsets.all(0).add(padding!)
                    : const EdgeInsets.all(0))
                .copyWith(
                elevation: MaterialStateProperty.all(0),
                overlayColor: MaterialStateProperty.all(
                    splashFactory == NoSplash.splashFactory
                        ? Colors.transparent
                        : Theme.of(context).splashColor)),
            child: child));
  }
}

enum ButtonTypes {
  roundedRectangle,
  circle,
  oval,
}

class LevelButtonTypes {
  static ButtonTypes get roundedRectangle => ButtonTypes.roundedRectangle;

  static ButtonTypes get circle => ButtonTypes.circle;

  static ButtonTypes get oval => ButtonTypes.oval;
}

enum ButtonPositions {
  start,
  between,
  end,
}

class LevelSegmentedButtonPositions {
  static ButtonPositions get start => ButtonPositions.start;

  static ButtonPositions get between => ButtonPositions.between;

  static ButtonPositions get end => ButtonPositions.end;
}
