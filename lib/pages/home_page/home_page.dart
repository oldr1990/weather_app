import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/pages/home_page/home_cubit.dart';
import 'package:weather_app/pages/home_page/home_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String route = "/home";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeCubit(), child: const HomeScreen());
  }
}
