import 'package:chapter/challenges_module/bloc/user_challenge_cubit.dart';
import 'package:chapter/challenges_module/components/challenge_card_widget.dart';
import 'package:chapter/challenges_module/model/user_challenge_and_challenges_model.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/utility/constants/asset_paths.dart';
import 'package:chapter/utility/messengers/core_loading_dialog.dart';
import 'package:chapter/utility/messengers/core_scaffold_messenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ChallengeView extends StatefulWidget {
  const ChallengeView({super.key});

  @override
  State<ChallengeView> createState() => _ChallengeViewState();
}

class _ChallengeViewState extends State<ChallengeView> {
  late final UserChallengeCubit _userChallengeCubit;

  @override
  void initState() {
    _userChallengeCubit = BlocProvider.of<UserChallengeCubit>(context);

    _userChallengeCubit.getUserChallengesAndChallenges();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder(
        bloc: _userChallengeCubit,
        builder: (context, state) {
          if (state is UserChallengeSuccessState) {
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = state.challenges.userChallenges?[index];

                      return _buildActiveChallenge(userChallenge: item);
                    },
                    childCount: state.challenges.userChallenges?.length ?? 0,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 20),
                    child: Text(
                      "Explore Challenges",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildChallenges(
                    challenges: state.challenges.challenges ?? [],
                    enrolledInChallenge: state.challenges.enrolledInChallenge,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildActiveChallenge({required UserChallenges? userChallenge}) {
    final startDate = DateTime.tryParse(userChallenge?.startDate ?? '');
    final today = DateTime.now();

    final start = startDate != null
        ? DateTime(startDate.year, startDate.month, startDate.day)
        : DateTime(today.year, today.month, today.day);

    final now = DateTime(today.year, today.month, today.day);

    final challengeDay = now.difference(start).inDays + 1;
    return Column(
      children: [
        _buildStreak(0.6),
        Text(
          '#DAY $challengeDay',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.w700, color: CoreColors.brownBramble),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${userChallenge?.daysCompleted}/${userChallenge?.challenge?.daysRequired} Days Completed',
              style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: CoreColors.brownBramble),
            ),
            const SizedBox(width: 20),
            Text(
              '${userChallenge?.missedDays}/${userChallenge?.challenge?.flexibleDays} Lives Used',
              style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: CoreColors.brownBramble),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: ((userChallenge?.timeline?.length ?? 0) / 8) * 80,
          child: GridView(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              mainAxisExtent: 32,
              mainAxisSpacing: 12,
            ),
            children: userChallenge?.timeline?.entries.map((e) {
                  if (e.value == "ongoing") {
                    return Lottie.asset(
                      AssetPaths.liveLottie,
                      height: 36,
                      width: 36,
                    );
                  }

                  if (e.value == "completed") {
                    return Image.asset(
                      AssetPaths.checkCirclePNG,
                      height: 36,
                      width: 36,
                    );
                  }

                  if (e.value == "missed") {
                    return Image.asset(
                      AssetPaths.heartCirclePNG,
                      height: 36,
                      width: 36,
                    );
                  }

                  return const Icon(
                    Icons.circle,
                    color: CoreColors.smokeGrey50,
                    size: 36,
                  );
                }).toList() ??
                [],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: CoreColors.eggSour,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userChallenge?.challenge?.name ?? '-',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w500, color: CoreColors.brownBramble),
              ),
              const SizedBox(height: 2),
              Text(
                "Wisdom builds day by day—keep going!",
                style:
                    Theme.of(context).textTheme.bodyLarge?.copyWith(color: CoreColors.brownBramble),
              ),
              const SizedBox(height: 8),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: CoreColors.darkOrange,
                ),
                child: Center(
                  child: Text(
                    "Continue Day $challengeDay",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildChallenges({required List<Challenge> challenges, bool? enrolledInChallenge}) {
    final challengeList = List.generate(
      challenges.length,
      (index) {
        final item = challenges[index];
        return ChallengeCardWidget(
          challenge: item,
          maxWidth: enrolledInChallenge == true ? MediaQuery.of(context).size.width * 0.8 : null,
          margin: enrolledInChallenge == true
              ? EdgeInsets.only(left: 16, right: challenges.length == index + 1 ? 16 : 0)
              : null,
          onTap: () async {
            if (enrolledInChallenge == true) {
              coreMessenger(
                "Already enrolled in a challenge",
                messageType: CoreScaffoldMessengerType.information,
              );
              return;
            }

            coreLoadingDialog(context: context, content: "Starting a challenge");

            final response = await _userChallengeCubit.startChallenge(challengeId: item.id);

            coreCloseDialog();

            if (response == null || response?['status'] == 0) {
              coreMessenger(
                "Error starting challenge",
                messageType: CoreScaffoldMessengerType.information,
              );
              return;
            }

            _userChallengeCubit.getUserChallengesAndChallenges();
          },
        );
      },
    );

    if (enrolledInChallenge == true) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: challengeList,
        ),
      );
    }

    return Column(
      children: challengeList,
    );
  }

  Widget _buildStreak(double? percentage) {
    String asset;
    double size;

    if (percentage == null || percentage < 0.3) {
      asset = AssetPaths.noStreakLottie;
      size = 100;
    } else if (percentage < 0.5) {
      asset = AssetPaths.lowStreakLottie;
      size = 140;
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
