import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/pages/bpm280_page/Bmp280_screen.dart';
import 'package:weather_app/pages/bpm280_page/bmp280_cubit.dart';
import 'models/device.dart';
import 'pages/ds18b20_page/ds18b20_cubit.dart';
import 'pages/ds18b20_page/ds18b20_screen.dart';
import 'pages/edit_device_page/edit_device_cubit.dart';
import 'pages/edit_device_page/edit_device_screen.dart';
import 'pages/home_page/home_cubit.dart';
import 'pages/auth_page/auth_cubit.dart';
import 'pages/auth_page/auth_screen.dart';
import 'pages/home_page/home_screen.dart';

Route<dynamic>? Function(RouteSettings)? navigation = (settings) {
  if (settings.name == AppRoutes.ds18b20.name) {
    final args = settings.arguments as Device;
    return MaterialPageRoute(builder: (context) {
      return BlocProvider(
          create: (context) => Ds18b20Cubit(),
          child: Ds18b20Screen(device: args));
    });
  } else if (settings.name == AppRoutes.bmp280.name) {
    final args = settings.arguments as Device;
    return MaterialPageRoute(builder: (context) {
      return BlocProvider(
          create: (context) => Bmp280Cubit(),
          child: Bmp280Screen(device: args));
    });
  } else if (settings.name == AppRoutes.editDevice.name) {
    final args = settings.arguments as Device?;
    return MaterialPageRoute(builder: (context) {
      return BlocProvider(
          create: (context) => EditDeviceCubit(),
          child: EditDeviceScreen(oldDevice: args));
    });
  } else if (settings.name == AppRoutes.home.name) {
    return MaterialPageRoute(builder: (context) {
      return BlocProvider(
          create: (context) => HomeCubit(), child: const HomeScreen());
    });
  } else if (settings.name == AppRoutes.auth.name) {
    return MaterialPageRoute(builder: (context) {
      return BlocProvider(
          create: (context) => AuthCubit(), child: const AuthScreen());
    });
  }
  return null;
};

enum AppRoutes { auth, home, editDevice, ds18b20, bmp280 }
