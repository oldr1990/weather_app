import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather_app/models/device.dart';
import 'package:weather_app/pages/ds18b20_page/ds18b20_cubit.dart';

class Ds18b20Screen extends StatefulWidget {
  const Ds18b20Screen({Key? key}) : super(key: key);

  @override
  State<Ds18b20Screen> createState() => _Ds18b20ScreenState();
}

class _Ds18b20ScreenState extends State<Ds18b20Screen> {
  Device? _device;
  @override
  void initState() {
    context.read<Ds18b20Cubit>().getDs18b20();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_device == null) {
      getArgs(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _device?.name ?? '',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: BlocConsumer<Ds18b20Cubit, Ds18b20State>(
        buildWhen: (previous, current) => current is Ds18b20Loading,
        builder: (context, state) {
          context.loaderOverlay.hide();
          if (state is Ds18b20Error) {
            return Container();
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is Ds18b20Loading) {
            context.loaderOverlay.show();
          }
        },
      ),
    );
  }

  Device? getArgs(BuildContext context) =>
      _device = ModalRoute.of(context)!.settings.arguments as Device?;
}
