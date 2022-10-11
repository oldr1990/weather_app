import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FooterListTileComponent extends StatelessWidget {
  final bool isEnd;
  const FooterListTileComponent({Key? key, required this.isEnd})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 16,
          ),
          if (isEnd)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue.shade200,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  AppLocalizations.of(context)!.erro_no_data_for_period,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            )
          else
            const CircularProgressIndicator(),
          const SizedBox(
            height: 32,
          ),
        ],
      );
}
