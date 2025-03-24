import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/user_module/cubit/user_activity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserActivityView extends StatefulWidget {
  const UserActivityView({super.key});

  @override
  State<UserActivityView> createState() => _UserActivityViewState();
}

class _UserActivityViewState extends State<UserActivityView> {
  @override
  void initState() {
    BlocProvider.of<UserActivityCubit>(context).getUserActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserActivityCubit, UserActivityState>(
      builder: (context, state) {
        if (state is UserActivitySuccessState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(state.userActivity.streak),
              CalenderMonthView(readCalendar: state.userActivity.readCalendar ?? {}),

              Text("Month History"),

              ListView.builder(
                shrinkWrap: true,
                itemCount: state.userActivity.userActivity?.length ?? 0,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = state.userActivity.userActivity?[index];
                  return ListTile(
                    title: Text("Chapter ${item?.chapterId} - Verse ${item?.verseId}"),
                    subtitle: Text("${item?.createdAt}"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  );
                },
              ),
            ],
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class CalenderMonthView extends StatefulWidget {
  const CalenderMonthView({super.key, required this.readCalendar});

  final Map<DateTime, bool> readCalendar;

  @override
  State<CalenderMonthView> createState() => _CalenderMonthViewState();
}

class _CalenderMonthViewState extends State<CalenderMonthView> {
  late final List<String> _weekdays;
  late final List<DateTime> _displayDates;
  late final DateTime _currentDate;

  List<DateTime> getDisplayDates(DateTime currentDate) {
    final firstDateOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final lastDateOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

    DateTime firstDisplayDate = firstDateOfMonth;
    DateTime lastDisplayDate = lastDateOfMonth;

    DateTime indexDate = firstDisplayDate;

    while (indexDate.weekday != DateTime.sunday) {
      indexDate = indexDate.subtract(const Duration(days: 1));
    }

    firstDisplayDate = indexDate;

    indexDate = lastDisplayDate;
    while (indexDate.weekday != DateTime.saturday) {
      indexDate = indexDate.add(const Duration(days: 1));
    }
    lastDisplayDate = indexDate.add(const Duration(days: 1));

    List<DateTime> dates = [];

    indexDate = firstDisplayDate;
    while (indexDate.isBefore(lastDisplayDate)) {
      dates.add(indexDate);

      indexDate = indexDate.add(const Duration(days: 1));
    }

    return dates;
  }

  @override
  void initState() {
    _currentDate = DateTime.now();
    _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    _displayDates = getDisplayDates(_currentDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(
            _weekdays.length,
            (index) {
              return Flexible(
                child: Container(
                  alignment: Alignment.center,
                  color: CoreColors.lavenderBlush,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _weekdays[index],
                    style:
                        Theme.of(context).textTheme.labelLarge?.copyWith(color: CoreColors.brown),
                  ),
                ),
              );
            },
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: _displayDates.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 40,
          ),
          itemBuilder: (context, index) {
            final date = _displayDates[index];
            TextStyle? textStyle = Theme.of(context).textTheme.bodySmall;

            if (date.month != _currentDate.month) {
              textStyle = textStyle?.copyWith(color: Colors.grey);
            } else if (widget.readCalendar.containsKey(date)) {
              bool isRead = widget.readCalendar[date] ?? false;

              if (isRead) {
                textStyle = textStyle?.copyWith(color: CoreColors.shareGreen);
              } else {
                if (date.day == _currentDate.day) {
                  textStyle = textStyle?.copyWith(color: CoreColors.fuelYellow);
                } else {
                  textStyle = textStyle?.copyWith(color: CoreColors.cadmiumRed);
                }
              }
            } else {
              textStyle = textStyle?.copyWith(color: Colors.black);
            }

            return Center(
              child: Text(
                date.day.toString(),
                style: textStyle,
              ),
            );
          },
        ),
      ],
    );
  }
}
