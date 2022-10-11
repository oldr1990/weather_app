// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:weather_app/utils/get_messages.dart';

class ListDateHeader extends StatelessWidget {
  final DateTime dateTime;
  const ListDateHeader({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateTime.getWeekdayLabel(context),
              style: Theme.of(context).textTheme.headline2,
            ),
            Row(
              children: [
                Text(
                  dateTime.day.toString(),
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  dateTime.getMonthLabel(context),
                  style: Theme.of(context).textTheme.headline2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
