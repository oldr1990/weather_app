import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather_app/models/device.dart';
import 'package:weather_app/pages/edit_device_page/edit_device_cubit.dart';

class EditDeviceScreen extends StatefulWidget {
  const EditDeviceScreen({Key? key}) : super(key: key);

  @override
  State<EditDeviceScreen> createState() => _EditDeviceScreenState();
}

class _EditDeviceScreenState extends State<EditDeviceScreen> {
  Device? oldDevice;
  @override
  Widget build(BuildContext context) {
    return BlocListener<EditDeviceCubit, EditDeviceState>(
      listenWhen: (previous, current) => true,
      listener: (context, state) {
        if (state is EditDeviceInitial) {
          context.loaderOverlay.hide();
          oldDevice = ModalRoute.of(context)!.settings.arguments as Device?;
        } else if (state is EditDeviceSuccess) {
          context.loaderOverlay.hide();
          Navigator.pop(context, 'Устройство успешно добавлено/изменено!');
        } else if (state is EditDeviceLoading) {
          context.loaderOverlay.show();
        } else if (state is EditDeviceFailure) {
          context.loaderOverlay.hide();
          Navigator.pop(context, state.errorMessage);
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              'Редактор устройств',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [],
            ),
          )),
    );
  }

  Widget _buildEditText(String hint, TextEditingController controller,
      bool validated, String errorMessage, bool isLast, int length) {
    return Expanded(
      child: TextField(
        maxLines: 1,
        maxLength: length,
        controller: controller,
        decoration: InputDecoration(
          errorText: validated ? errorMessage : null,
          labelText: hint,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      ),
    );
  }
}
