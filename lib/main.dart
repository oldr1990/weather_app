import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather_app/pages/auth_page/auth_page.dart';
import 'package:weather_app/pages/auth_page/auth_screen.dart';
import 'package:weather_app/settings/theme.dart';

void main() {
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
    return GlobalLoaderOverlay(
      child: MaterialApp(
        routes: {
          AuthPage.route: (context) => const AuthPage(),
        },
        theme: WeatherAppTheme.dark(),
        home: const AuthPage(),
      ),
    );
  }
}
