import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/pages/edit_device_page/edit_device_cubit.dart';
import 'package:weather_app/pages/edit_device_page/edit_device_screen.dart';

class EditDevicePage extends StatelessWidget {
  const EditDevicePage({Key? key}) : super(key: key);
  static const String route = "/edit_device";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EditDeviceCubit(),
        child: const EditDeviceScreen());
  }
}
