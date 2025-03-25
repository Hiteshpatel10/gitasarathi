import 'package:chapter/theme/core_colors.dart';
import 'package:flutter/material.dart';

class CalenderMonthWidget extends StatefulWidget {
  const CalenderMonthWidget({super.key, required this.readCalendar});

  final Map<DateTime, bool> readCalendar;

  @override
  State<CalenderMonthWidget> createState() => _CalenderMonthWidgetState();
}

class _CalenderMonthWidgetState extends State<CalenderMonthWidget> {
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
                  color: CoreColors.dawnPink,
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