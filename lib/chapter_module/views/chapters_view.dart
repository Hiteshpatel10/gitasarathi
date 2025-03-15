import 'package:chapter/chapter_module/bloc/chapters_and_verse_cubit.dart';
import 'package:chapter/chapter_module/bloc/user_activity_cubit.dart';
import 'package:chapter/chapter_module/model/chapter_model.dart';
import 'package:chapter/chapter_module/model/user_activity_model.dart';
import 'package:chapter/components/parallax_container.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChaptersView extends StatefulWidget {
  const ChaptersView({super.key});

  @override
  State<ChaptersView> createState() => _ChaptersViewState();
}

class _ChaptersViewState extends State<ChaptersView> {
  late final ChapterModel _chapterModel;

  @override
  void initState() {
    FirebaseAnalyticsService().init();

    _chapterModel = ChapterModel.fromJson(chapterData);
    // BlocProvider.of<ChapterCubit>(context).getUser(context);
    BlocProvider.of<UserActivityCubit>(context).getUserActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<ChaptersAndVerseCubit, ChaptersAndVerseState>(builder: (context, state) {
        // if (state is SuccessState) {
        //   return CustomScrollView(
        //     slivers: [
        //       const SliverAppBar(
        //         expandedHeight: 60,
        //         flexibleSpace: FlexibleSpaceBar(
        //           background: UserWeekActivityWidget(),
        //         ),
        //       ),
        //       SliverList(
        //         delegate: SliverChildBuilderDelegate(
        //           childCount: _chapterModel.chapters?.length ?? 0,
        //           (context, index) {
        //             final chapter = _chapterModel.chapters?[index];
        //
        //             return GestureDetector(
        //               onTap: () {
        //                 context.pushNamed(
        //                   AppRoutes.chapterDetail,
        //                   extra: {
        //                     "chapter_no": index,
        //                   },
        //                 );
        //               },
        //               child: ParallaxContainer(
        //                 imageUrl: '${ApiEndpoints.s3BaseURL}ch${index + 1}.png',
        //                 name: chapter?.title ?? '-',
        //                 progress: state.state.result?.reads?[index].progress,
        //                 country: "Chapter ${index + 1}",
        //               ),
        //             );
        //           },
        //         ),
        //       ),
        //       const SliverToBoxAdapter(
        //         child: SizedBox(height: 400),
        //       )
        //     ],
        //   );
        // }

        if (state is LoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return const Text("sdfjs");
      }),
    );
  }
}

class UserWeekActivityWidget extends StatefulWidget {
  const UserWeekActivityWidget({super.key});

  @override
  State<UserWeekActivityWidget> createState() => _UserWeekActivityWidgetState();
}

class _UserWeekActivityWidgetState extends State<UserWeekActivityWidget> {
  final daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  ActivityStatus getActivityStatus(List<Activity>? activity, String? day) {
    final today = DateTime.now().weekday;

    if (activity == null) {
      return ActivityStatus.upcoming;
    }

    if ((activity.isEmpty == true) && daysOfWeek[today] == day) {
      return ActivityStatus.ongoing;
    }

    if (activity.isEmpty == true) {
      return ActivityStatus.skipped;
    }

    if (activity.isNotEmpty == true) {
      return ActivityStatus.done;
    }

    return ActivityStatus.skipped;
  }

  // New method to get icon and color based on ActivityStatus
  Map<String, dynamic> getIconAndColor(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.done:
        return {
          'icon': Icons.check_circle,
          'color': Colors.green,
        };
      case ActivityStatus.skipped:
        return {
          'icon': Icons.cancel,
          'color': Colors.red,
        };
      case ActivityStatus.ongoing:
        return {
          'icon': Icons.access_time_filled_sharp,
          'color': Colors.orange,
        };
      case ActivityStatus.upcoming:
        return {
          'icon': Icons.circle,
          'color': Colors.blue,
        };
      default:
        return {
          'icon': Icons.help_outline,
          'color': Colors.grey,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserActivityCubit, UserActivityState>(
      builder: (context, state) {
        if (state is UserActivitySuccess) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                state.userActivity.result?.length ?? 0,
                (index) {
                  final activity = state.userActivity.result?[index];
                  final activityStatus = getActivityStatus(activity?.activity, activity?.day);
                  final iconAndColor = getIconAndColor(activityStatus);

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    constraints: const BoxConstraints(minWidth: 42),
                    decoration: BoxDecoration(
                      color: activityStatus == ActivityStatus.upcoming ? null : iconAndColor['color'],
                      borderRadius: BorderRadius.circular(8),
                      border: activityStatus == ActivityStatus.upcoming
                          ? Border.all(color: iconAndColor['color'])
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          activity?.day?.substring(0, 3) ?? '-',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Icon(
                          iconAndColor['icon'],
                          size: 18,
                          color: activityStatus == ActivityStatus.upcoming
                              ? iconAndColor['color']
                              : Colors.white,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

final list = [
  "Arjuna Vishada Yoga",
  "Sankhya Yoga",
  "Karma Yoga",
  "Jnana Karma Sanyasa Yoga",
  "Karma Sanyasa Yoga",
  "Dhyana Yoga",
  "Jnana Vijnana Yoga",
  "Aksara Brahma Yoga",
  "Raja Vidya Raja Guhya Yoga",
  "Vibhuti Yoga",
  "Visvarupa Darshana Yoga",
  "Bhakti Yoga",
  "Kshetra Kshetragna Vibhaga Yoga",
  "Gunatraya Vibhaga Yoga",
  "Purusottama Yoga",
  "Daivasura Sampad Vibhaga Yoga",
  "Sraddhatraya Vibhaga Yoga",
  "Moksha Sanyasa Yoga",
];

enum ActivityStatus {
  done,
  skipped,
  ongoing,
  upcoming,
}
