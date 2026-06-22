import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/core/theme/app_colors.dart';

class ExperienceSelector extends StatelessWidget {
  const ExperienceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose your experience",
          style: GoogleFonts.lora(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: context.colors.label,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.secondarySystemBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.menu_book, color: context.colors.saffron, size: 28),
                    const SizedBox(height: 24),
                    Text(
                      'Read',
                      style: GoogleFonts.lora(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.colors.label,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Continue Chapter 3',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.secondarySystemBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.headphones, color: context.colors.saffron, size: 28),
                    const SizedBox(height: 24),
                    Text(
                      'Listen',
                      style: GoogleFonts.lora(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.colors.label,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Audiobook · English',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
