import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/components/components.dart';
import 'package:weather_app/models/device.dart';
import 'package:weather_app/pages/ds18b20_page/ds18b20_page.dart';
import 'package:weather_app/pages/edit_device_page/edit_device_page.dart';
import 'package:weather_app/pages/home_page/home_cubit.dart';
import 'package:weather_app/utils/get_messages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/device_type.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppLocalizations? _stringRes;

  @override
  void initState() {
    refresh();
    super.initState();
  }

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
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is HomeSuccess) {
            return _buildDeviceList(state.devices);
          } else {
            state as HomeFailure;
            return ErrorComponent(
                onRetry: refresh,
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
            _navigateToEditPage(context, null),
          },
          child: const Icon(
            Icons.add,
            size: 32,
          ),
        ),
      ),
    );
  }

  Future refresh() async {
    context.read<HomeCubit>().loadDevicesList();
  }

  Widget _buildDeviceList(List<Device> devices) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        itemCount: devices.isEmpty ? 1 : devices.length,
        itemBuilder: (context, index) {
          if (devices.isNotEmpty) {
            return DeviceComponent(
                onTap: () => {_navigateToDeviceData(devices[index])},
                editTap: () => {_navigateToEditPage(context, devices[index])},
                device: devices[index]);
          } else {
            return _buildAddDevice();
          }
        },
      ),
    );
  }

  void _navigateToDeviceData(Device device) {
    switch (device.deviceType()) {
      case DeviceType.ds18b20:
        Navigator.pushNamed(context, Ds18b20Page.route, arguments: device);
        break;
      default:
        break;
    }
  }

  Future<void> _navigateToEditPage(BuildContext context, Device? device) async {
    final result = await Navigator.pushNamed(
      context,
      EditDevicePage.route,
      arguments: device,
    );
    if (result != null && result is String) {
      showSnackbar(context, result);
    }
    refresh();
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_stringRes!.add_device,
                            style: Theme.of(context).textTheme.headline2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
