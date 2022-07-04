import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather_app/pages/auth_page/auth_page.dart';
import 'package:weather_app/settings/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var localizationsDelegates2 = [
      AppLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ];
    var locale = const Locale('ru', '');
    return GlobalLoaderOverlay(
      child: MaterialApp(
        supportedLocales: [
          locale,
        ],
        localizationsDelegates: localizationsDelegates2,
        routes: navigationRoutes,
        theme: WeatherAppTheme.dark(),
        home: const AuthPage(),
      ),
    );
  }
}
