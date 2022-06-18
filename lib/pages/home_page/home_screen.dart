import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/components/error_component.dart';
import 'package:weather_app/pages/home_page/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String route = "/auth";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeEmpty) {
          return const Center(
            child: Text("No devices"),
          );
        } else if (state is HomeSuccess) {
          return const Center(
            child: Text("Success"),
          );
        } else {
          state as HomeFailure;
          return ErrorComponent(
              onRetry: () => {}, errorMessage: state.errorMessage);
        }
      },
    );
  }
}
