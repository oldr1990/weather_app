import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PressureTile extends StatelessWidget {
  final double pressure;

  const PressureTile({Key? key, required this.pressure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppLocalizations.of(context)!.pressure + ": ",
            style: Theme.of(context).textTheme.headline3),
        Flexible(
          child: Text(
            (pressure ~/ 133.322).toString() +
                AppLocalizations.of(context)!.pressure_measurement,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ],
    );
  }
}
