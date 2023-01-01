import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/utils/math_util.dart';

class TemperatureTile extends StatelessWidget {
  final double temperature;

  const TemperatureTile({Key? key, required this.temperature})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppLocalizations.of(context)!.temperature + ": ",
            style: Theme.of(context).textTheme.headline3),
        Flexible(
          child: Text(
            temperature.toString() + " °C",
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: _getColor()),
          ),
        ),
      ],
    );
  }

  Color _getColor() {
    if (temperature > 22.5) {
      return Color.lerp(Colors.orange, Colors.red,
          rangeConverterDouble(22.5, 30, 0, 1, clampedTemp()))!;
    } else {
      return Color.lerp(Colors.blue, Colors.orange,
          rangeConverterDouble(15, 22.5, 0, 1, clampedTemp()))!;
    }
  }

  double clampedTemp() => temperature.clamp(15, 30);
}
