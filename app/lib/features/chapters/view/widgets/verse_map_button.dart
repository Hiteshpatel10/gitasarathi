import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/widgets/push_button.dart';

enum VerseState {
  completed,
  current,
  locked,
}

class VerseMapButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    Color topColor;
    Color? bottomColor;
    Color textColor;
    BorderSide? borderSide;
    List<BoxShadow> shadows = [];
    double buttonDepth = 0;

    switch (state) {
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
        textColor = colors.label.withValues(alpha: 0.8);
        borderSide = BorderSide(color: colors.label.withValues(alpha: 0.3), width: 1);
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
      onPressed: onTap,
      child: Center(
        child: Text(
          '$verseNumber',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    if (state == VerseState.current) {
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
