import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/widgets/push_button.dart';

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
    Color? bottomColor;
    Color textColor;
    BorderSide? borderSide;
    List<BoxShadow> shadows = [];
    double buttonDepth = 0;

    switch (widget.state) {
      case VerseState.completed:
        topColor = colors.saffron;
        bottomColor = const Color(0xFFC07628); // Darker orange for 3D depth
        textColor = Colors.white;
        buttonDepth = 6;
        break;
      case VerseState.current:
        topColor = colors.systemBackground;
        textColor = colors.saffron;
        borderSide = BorderSide(color: colors.saffron, width: 2);
        buttonDepth = 0; // Flat
        shadows = [
          BoxShadow(
            color: colors.saffron.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 8,
          )
        ];
        break;
      case VerseState.locked:
        topColor = colors.systemBackground;
        textColor = Colors.white.withValues(alpha: 0.4);
        borderSide = BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1);
        buttonDepth = 0; // Flat
        break;
    }

    Widget button = LevelAnimatedButton(
      width: 60,
      height: 60,
      buttonHeight: buttonDepth,
      buttonType: ButtonTypes.circle,
      buttonColor: topColor,
      backgroundColor: bottomColor,
      side: borderSide,
      onPressed: widget.state != VerseState.locked ? widget.onTap : null,
      child: Center(
        child: Text(
          '${widget.verseNumber}',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    if (widget.state == VerseState.current) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Aura Glow
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: shadows,
            ),
          ),
          button,
          // START Badge
          Positioned(
            top: -12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colors.systemBackground,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: colors.saffron, width: 1),
              ),
              child: Text(
                'START',
                style: TextStyle(
                  color: colors.saffron,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return button;
  }
}
