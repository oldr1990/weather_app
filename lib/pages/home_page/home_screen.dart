import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/components/device_component.dart';
import 'package:weather_app/components/error_component.dart';
import 'package:weather_app/models/device.dart';
import 'package:weather_app/pages/edit_device_page/edit_device_page.dart';
import 'package:weather_app/pages/home_page/home_cubit.dart';
import 'package:weather_app/utils/get_error_message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppLocalizations? _stringRes;

  @override
  Widget build(BuildContext context) {
    _stringRes = AppLocalizations.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          _stringRes!.devices,
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
                errorMessage: state.error.getErrorMessage(context));
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          tooltip: _stringRes!.add_device,
          elevation: 4,
          backgroundColor: Theme.of(context).backgroundColor,
          onPressed: () => {
            Navigator.pushNamed(context, EditDevicePage.route),
          },
          child: const Icon(
            Icons.add,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceList(List<Device> devices) {
    return ListView.builder(
      itemCount: devices.isEmpty ? 1 : devices.length,
      itemBuilder: (context, index) {
        if (devices.isNotEmpty) {
          return DeviceComponent(
              onTap: () => {
                    Navigator.pushNamed(
                      context,
                      EditDevicePage.route,
                      arguments: devices[index],
                    ),
                  },
              device: devices[index]);
        } else {
          return _buildAddDevice();
        }
      },
    );
  }

  Widget _buildAddDevice() {
    return GestureDetector(
        onTap: () => {Navigator.pushNamed(context, EditDevicePage.route)},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.add,
                    color: Colors.grey,
                    size: 40,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_stringRes!.add_device,
                              style: Theme.of(context).textTheme.headline2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
