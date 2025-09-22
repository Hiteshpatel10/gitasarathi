import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:chapter/main.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/utility/constants/asset_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

class StreakCelebrationView extends StatefulWidget {
  const StreakCelebrationView({
    super.key,
    this.returnTo,
    required this.currentStreak,
  });

  final String? returnTo;
  final num currentStreak;

  @override
  State<StreakCelebrationView> createState() => _StreakCelebrationViewState();
}

class _StreakCelebrationViewState extends State<StreakCelebrationView>
    with SingleTickerProviderStateMixin {
  late num streakValue;
  late AudioPlayer _audioPlayer;
  double _lottieScale = 1.0;
  Color? backgroundColor;
  double _textOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    streakValue = widget.currentStreak - 1;
    _audioPlayer = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scale + Color + Audio
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {
          _lottieScale = 1.5;
          backgroundColor = CoreColors.fuelYellowLight;
        });

        try {
          _audioPlayer.play(AssetSource('audio/fire_sfx.mp3'));
        } catch (e) {
          logger.e("Audio Error: $e");
        }
      });

      // Update the counter
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          streakValue = widget.currentStreak;
        });
      });

      // Fade in text
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _textOpacity = 1.0;
        });
      });

      // Navigate out
      Future.delayed(const Duration(milliseconds: 2500), () {
        _handleNavigation();
      });
    });
  }

  void _handleNavigation() {
    if (widget.returnTo == null || widget.returnTo!.isEmpty) {
      GoRouter.of(context).pop();
    } else {
      GoRouter.of(context).pushReplacement(widget.returnTo!);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.only(bottom: 100),
          color: backgroundColor ?? Colors.white,
          child: Center(
            child: AnimatedScale(
              scale: _lottieScale,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LottieBuilder.asset(
                    AssetPaths.lowStreakLottie,
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 20),
                  AnimatedFlipCounter(
                    value: streakValue,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutExpo,
                    textStyle: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontWeight: FontWeight.w700, color: CoreColors.brown),
                  ),
                  const SizedBox(height: 8),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 600),
                    opacity: _textOpacity,
                    child: Text(
                      "Day Streak",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: CoreColors.brown),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
