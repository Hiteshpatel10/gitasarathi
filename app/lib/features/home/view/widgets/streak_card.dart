import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/core/theme/app_colors.dart';
import '../../provider/home_providers.dart';

class StreakCard extends ConsumerWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakSummaryProvider);

    return Container(
      decoration: BoxDecoration(
        color: context.colors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: streakAsync.when(
        data: (summary) {
          if (summary == null) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${summary.currentStreak} Day Streak',
                        style: GoogleFonts.lora(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.colors.label,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Keep the fire alive',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.colors.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.local_fire_department, color: context.colors.saffron, size: 28),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: summary.last7Days.map((day) {
                  return Column(
                    children: [
                      Text(
                        day.day,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: context.colors.secondaryLabel,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: day.read ? context.colors.saffron : context.colors.separator,
                          boxShadow: day.read
                              ? [
                                  BoxShadow(
                                    color: context.colors.saffron.withValues(alpha: 0.5),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  )
                                ]
                              : null,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Text('Failed to load'),
      ),
    );
  }
}
