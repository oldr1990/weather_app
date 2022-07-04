import 'package:flutter/material.dart';
import 'pages/auth_page/auth_page.dart';
import 'pages/ds18b20_page/ds18b20_page.dart';
import 'pages/edit_device_page/edit_device_page.dart';
import 'pages/home_page/home_page.dart';

Map<String, Widget Function(BuildContext)> navigationRoutes = {
  AuthPage.route: (context) => const AuthPage(),
  HomePage.route: (context) => const HomePage(),
  EditDevicePage.route: (context) => const EditDevicePage(),
  Ds18b20Page.route: (context) => const Ds18b20Page(),
};