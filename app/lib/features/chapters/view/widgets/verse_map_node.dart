import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'verse_map_button.dart';
import 'package:app/core/theme/app_colors.dart';

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

  static const double nodeHeight = 120.0;
  static const double amplitude = 100.0;
  static const double frequency = 0.6;

  @override
  Widget build(BuildContext context) {
    // Current, previous, and next X offsets based on sine wave
    final currX = math.sin(index * frequency) * amplitude;
    final prevX = math.sin((index - 1) * frequency) * amplitude;
    final nextX = math.sin((index + 1) * frequency) * amplitude;

    final colors = context.colors;
    final pathColor = state == VerseState.completed || state == VerseState.current 
        ? colors.saffron 
        : Colors.white.withValues(alpha: 0.1);

    return SizedBox(
      height: nodeHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Path
          Positioned.fill(
            child: CustomPaint(
              painter: _MapPathPainter(
                currX: currX,
                prevX: prevX,
                nextX: nextX,
                isFirst: isFirst,
                isLast: isLast,
                pathColor: pathColor,
              ),
            ),
          ),
          
          // Button
          Transform.translate(
            offset: Offset(currX, 0),
            child: VerseMapButton(
              verseNumber: verseNumber,
              state: state,
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPathPainter extends CustomPainter {
  final double currX;
  final double prevX;
  final double nextX;
  final bool isFirst;
  final bool isLast;
  final Color pathColor;

  _MapPathPainter({
    required this.currX,
    required this.prevX,
    required this.nextX,
    required this.isFirst,
    required this.isLast,
    required this.pathColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = pathColor
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    
    final path = Path();
    
    // Start from top (previous node) if not first
    if (!isFirst) {
      final prevCenter = Offset(center.dx + prevX, -size.height / 2);
      final currentCenter = Offset(center.dx + currX, center.dy);
      
      path.moveTo(prevCenter.dx, prevCenter.dy);
      // Smooth curve to current
      path.quadraticBezierTo(
        prevCenter.dx, 
        currentCenter.dy - size.height / 4, 
        currentCenter.dx, 
        currentCenter.dy
      );
    } else {
      path.moveTo(center.dx + currX, center.dy);
    }

    // Go to bottom (next node) if not last
    if (!isLast) {
      final currentCenter = Offset(center.dx + currX, center.dy);
      final nextCenter = Offset(center.dx + nextX, size.height + size.height / 2);
      
      path.moveTo(currentCenter.dx, currentCenter.dy);
      // Smooth curve to next
      path.quadraticBezierTo(
        currentCenter.dx, 
        currentCenter.dy + size.height / 4, 
        nextCenter.dx, 
        nextCenter.dy
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MapPathPainter oldDelegate) {
    return oldDelegate.currX != currX ||
           oldDelegate.pathColor != pathColor ||
           oldDelegate.isFirst != isFirst ||
           oldDelegate.isLast != isLast;
  }
}
