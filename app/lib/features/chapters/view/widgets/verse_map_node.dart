import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'verse_map_button.dart';

class VerseMapNode extends StatelessWidget {
  const VerseMapNode({
    super.key,
    required this.index,
    required this.verseNumber,
    required this.isFirst,
    required this.isLast,
    required this.state,
    required this.onTap,
  });

  final int index;
  final int verseNumber;
  final bool isFirst;
  final bool isLast;
  final VerseState state;
  final VoidCallback onTap;

  static const double nodeHeight = 80.0; 

  @override
  Widget build(BuildContext context) {
    // Static snake pattern (no scrolling parallax)
    final offsetX = 100 * math.sin(index * 1.0);

    return Transform.translate(
      offset: Offset(offsetX, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: VerseMapButton(
          verseNumber: verseNumber,
          state: state,
          onTap: onTap,
        ),
      ),
    );
  }
}
