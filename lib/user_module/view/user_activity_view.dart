import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/user_module/components/calender_month_view_widget.dart';
import 'package:chapter/user_module/cubit/user_activity_cubit.dart';
import 'package:chapter/utility/constants/asset_paths.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class UserActivityView extends StatefulWidget {
  const UserActivityView({super.key});

  @override
  State<UserActivityView> createState() => _UserActivityViewState();
}

class _UserActivityViewState extends State<UserActivityView> {
  @override
  void initState() {
    final now = DateTime.now();

    BlocProvider.of<UserActivityCubit>(context).getMonthlyUserActivity(
      month: now.month,
      year: now.year,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: BlocBuilder<UserActivityCubit, UserActivityState>(
        builder: (context, state) {
          if (state is UserActivitySuccessState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: _buildStreak(state.userActivity.streak),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: CoreColors.brown),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CalenderMonthWidget(
                        readCalendar: state.userActivity.readCalendar ?? {}),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      "Read History",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: state.userActivity.userActivity?.length ?? 0,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = state.userActivity.userActivity?[index];
                      return ListTile(
                        onTap: () {
                          GoRouter.of(context).pushNamed(
                            AppRoutes.verseExplanation.name,
                            pathParameters: {"verseId": "${item?.verseId}"},
                          );
                        },
                        title: Text(
                            "Chapter ${item?.chapterId} - Verse ${item?.verseId}"),
                        subtitle: Text("${item?.createdAt}"),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Divider(),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  List<Widget> _buildStreak(num? streak) {
    return [
      if (streak == 0 || streak == null) ...[
        LottieBuilder.asset(
          AssetPaths.noStreakLottie,
          height: 100,
          width: 100,
          repeat: false,
        ),
        Text(
          "0",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: CoreColors.textGrey),
        )
      ] else if (streak < 3) ...[
        LottieBuilder.asset(
          AssetPaths.maxStreakLottie,
          height: 160,
          width: 160,
          repeat: false,
        ),
        Text(
          "$streak",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: CoreColors.yellowishOrange),
        ),
      ] else ...[
        LottieBuilder.asset(
          AssetPaths.lowStreakLottie,
          height: 200,
          width: 200,
          repeat: false,
        ),
        Text(
          "$streak",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: CoreColors.brown),
        ),
      ],
      Text(
        "Read Streak",
        style: Theme.of(context).textTheme.bodyMedium,
      )
    ];
  }
}
