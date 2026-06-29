import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'widgets/home_header.dart';
import 'widgets/continue_reading_card.dart';
import 'widgets/streak_card.dart';
import 'widgets/todays_verse_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.systemBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              HomeHeader(),
              SizedBox(height: 24),
              ContinueReadingCard(),
              SizedBox(height: 24),
              StreakCard(),
              SizedBox(height: 24),
              TodaysVerseCard(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
