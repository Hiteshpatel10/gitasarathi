import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chapter/challenges_module/bloc/user_challenge_cubit.dart';
import 'package:chapter/challenges_module/model/user_challenge_and_challenges_model.dart';
import 'package:chapter/main.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/utility/constants/asset_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ChallengeCelebrationView extends StatefulWidget {
  const ChallengeCelebrationView({super.key, this.returnTo});

  final String? returnTo;
  @override
  State<ChallengeCelebrationView> createState() => _ChallengeCelebrationViewState();
}

class _ChallengeCelebrationViewState extends State<ChallengeCelebrationView>
    with SingleTickerProviderStateMixin {
  late final UserChallengeCubit _userChallengeCubit;

  int challengeDay = 0;
  num completedDay = 0;
  double _lottieScale = 1.0;
  Color? backgroundColor;
  UserChallenges? userChallenge;
  late AudioPlayer _audioPlayer;

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _userChallengeCubit = BlocProvider.of<UserChallengeCubit>(context);
    _audioPlayer = AudioPlayer();

    if (_userChallengeCubit.state is UserChallengeSuccessState) {
      final state = _userChallengeCubit.state as UserChallengeSuccessState;
      userChallenge = state.challenges.userChallenges?.first;
    }
    final startDate = DateTime.tryParse(userChallenge?.startDate ?? '');
    final today = DateTime.now();
    final start = startDate != null
        ? DateTime(startDate.year, startDate.month, startDate.day)
        : DateTime(today.year, today.month, today.day);
    final now = DateTime(today.year, today.month, today.day);

    challengeDay = now.difference(start).inDays + 1;

    completedDay = (userChallenge?.daysCompleted ?? 1) - 1;

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _progressAnimation = Tween<double>(
      begin: completedDay / (userChallenge?.challenge?.daysRequired ?? 1),
      end: (completedDay + 1) / (userChallenge?.challenge?.daysRequired ?? 1),
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOut,
    ));

    // Animate everything in sequence
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _lottieScale = 1.4;
          backgroundColor = CoreColors.eggSour;
          try {
            _audioPlayer.play(AssetSource('audio/fire_sfx.mp3'));
          } catch (e) {
            logger.e("Audio Error: $e");
          }
        });
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          completedDay = (userChallenge?.daysCompleted ?? 1);
        });
        _progressController.forward();
      });

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
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double percent =
        (userChallenge?.daysCompleted ?? 1) / (userChallenge?.challenge?.daysRequired ?? 1);

    return AnimatedContainer(
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
              _buildStreak(percent),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: 1,
                child: Text(
                  "#Day $challengeDay",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700, color: CoreColors.brownBramble),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedFlipCounter(
                    value: completedDay,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutExpo,
                    textStyle: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontWeight: FontWeight.w700, color: CoreColors.brownBramble),
                  ),
                  Text(
                    " / ${(userChallenge?.challenge?.daysRequired ?? 1)}",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontWeight: FontWeight.w700, color: CoreColors.brownBramble),
                  )
                ],
              ),
              Text(
                "Days Completed",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700, color: CoreColors.brownBramble),
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                    child: LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: CoreColors.brownBramble.withOpacity(0.2),
                      color: CoreColors.brownBramble,
                      minHeight: 10,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreak(double? percentage) {
    String asset;
    double size;

    if (percentage == null || percentage < 0.3) {
      asset = AssetPaths.lowStreakLottie;
      size = 100;
    } else if (percentage < 0.5) {
      asset = AssetPaths.maxStreakLottie;
      size = 200;
    } else {
      asset = AssetPaths.maxStreakLottie;
      size = percentage < 0.7 ? 160 : 200;
    }

    return LottieBuilder.asset(
      asset,
      height: size,
      width: size,
      repeat: false,
    );
  }
}
