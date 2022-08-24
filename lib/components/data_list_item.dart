import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataListItem extends StatelessWidget {
  final DateTime time;
  final List<Widget> children;
  const DataListItem({Key? key, required this.children, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              _time(context),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: children,
                ),
              ),
              const SizedBox(width: 16,)
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          _footer(context),
        ],
      );

  Widget _footer(BuildContext context) => Container(
        width: double.infinity,
        height: 2,
        color: Theme.of(context).appBarTheme.backgroundColor,
      );

  Widget _time(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          DateFormat('HH:mm').format(time),
          style: Theme.of(context).textTheme.headline2,
        ),
      );
}
