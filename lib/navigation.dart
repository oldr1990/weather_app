import 'package:flutter/material.dart';
import 'package:weather_app/models/device.dart';
import 'pages/auth_page/auth_page.dart';
import 'pages/ds18b20_page/ds18b20_page.dart';
import 'pages/edit_device_page/edit_device_page.dart';
import 'pages/home_page/home_page.dart';

Map<String, Widget Function(BuildContext)> navigationRoutes = {
  AuthPage.route: (context) => const AuthPage(),
  HomePage.route: (context) => const HomePage(),
};

Route<dynamic>? Function(RouteSettings)? navigationRoutesWithArgs = (settings) {
  switch (settings.name) {
    case Ds18b20Page.route:
      final args = settings.arguments as Device;
      return MaterialPageRoute(builder: (context) {
        return Ds18b20Page(device: args);
      });

    case EditDevicePage.route:
      final args = settings.arguments as Device?;
      return MaterialPageRoute(builder: (context) {
        return EditDevicePage(device: args);
      });
  }
  return null;
};
