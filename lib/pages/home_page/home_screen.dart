import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/components/device_component.dart';
import 'package:weather_app/components/error_component.dart';
import 'package:weather_app/models/device.dart';
import 'package:weather_app/pages/home_page/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Список датчиков',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            context.read<HomeCubit>().loadDevicesList();
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is HomeSuccess) {
            return _buildDeviceList(state.devices);
          } else {
            state as HomeFailure;
            return ErrorComponent(
                onRetry: () => {context.read<HomeCubit>().loadDevicesList()},
                errorMessage: state.errorMessage);
          }
        },
      ),
    );
  }

  Widget _buildDeviceList(List<Device> devices) {
    return ListView.builder(
      itemCount: devices.length + 1,
      itemBuilder: (context, index) {
        if (index == devices.length) {
          return DeviceComponent(onTap: () => {}, device: devices[index]);
        } else {
          return const Text("Add item");
        }
      },
    );
  }
}
