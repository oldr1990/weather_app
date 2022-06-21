import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather_app/pages/auth_page/auth_page.dart';
import 'package:weather_app/pages/home_page/home_page.dart';
import 'package:weather_app/pages/home_page/home_screen.dart';
import 'package:weather_app/settings/theme.dart';
import 'package:firebase_core/firebase_core.dart';

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
    return GlobalLoaderOverlay(
      child: MaterialApp(
        routes: {
          AuthPage.route: (context) => const AuthPage(),
          HomePage.route: (context) => const HomePage(),
        },
        theme: WeatherAppTheme.dark(),
        home: const AuthPage(),
      ),
    );
  }
}
