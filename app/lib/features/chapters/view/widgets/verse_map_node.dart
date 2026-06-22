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
    required this.scrollController,
    required this.onTap,
  });

  final int index;
  final int verseNumber;
  final bool isFirst;
  final bool isLast;
  final VerseState state;
  final ScrollController scrollController;
  final VoidCallback onTap;

  static const double nodeHeight = 80.0; // matched _gapHeight from old app

  @override
  Widget build(BuildContext context) {
    final baseY = index * nodeHeight;

    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        // Safe check for offset if controller not attached yet
        final offsetValue = scrollController.hasClients ? scrollController.offset : 0.0;
        
        final offsetX = 100 * math.sin((offsetValue + index * nodeHeight + baseY) / 150);

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
      },
    );
  }
}
