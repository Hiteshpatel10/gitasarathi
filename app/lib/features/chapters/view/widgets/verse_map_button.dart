import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';

enum VerseState {
  completed,
  current,
  locked,
}

class VerseMapButton extends StatefulWidget {
  const VerseMapButton({
    super.key,
    required this.verseNumber,
    required this.state,
    required this.onTap,
  });

  final int verseNumber;
  final VerseState state;
  final VoidCallback onTap;

  @override
  State<VerseMapButton> createState() => _VerseMapButtonState();
}

class _VerseMapButtonState extends State<VerseMapButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.state != VerseState.locked) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.state != VerseState.locked) {
      _controller.reverse();
      widget.onTap();
    }
  }

  void _onTapCancel() {
    if (widget.state != VerseState.locked) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    Color topColor;
    Color bottomColor;
    Color textColor;
    BoxBorder? border;
    List<BoxShadow> shadows = [];

    switch (widget.state) {
      case VerseState.completed:
        topColor = colors.saffron;
        bottomColor = colors.saffron.withValues(alpha: 0.7);
        textColor = Colors.white;
        shadows = [
          BoxShadow(
            color: colors.saffron.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ];
        break;
      case VerseState.current:
        topColor = colors.systemBackground;
        bottomColor = colors.systemBackground.withValues(alpha: 0.8);
        textColor = colors.saffron;
        border = Border.all(color: colors.saffron, width: 2);
        shadows = [
          BoxShadow(
            color: colors.saffron.withValues(alpha: 0.6),
            blurRadius: 12,
            spreadRadius: 2,
          )
        ];
        break;
      case VerseState.locked:
        topColor = Colors.white.withValues(alpha: 0.1);
        bottomColor = Colors.white.withValues(alpha: 0.05);
        textColor = Colors.white.withValues(alpha: 0.4);
        border = Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1);
        break;
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [topColor, bottomColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: border,
            boxShadow: shadows,
          ),
          alignment: Alignment.center,
          child: Text(
            '${widget.verseNumber}',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
