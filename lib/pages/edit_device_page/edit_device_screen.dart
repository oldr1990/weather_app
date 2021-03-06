import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather_app/components/button_component.dart';
import 'package:weather_app/models/device.dart';
import 'package:weather_app/models/device_type.dart';
import 'package:weather_app/pages/edit_device_page/edit_device_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditDeviceScreen extends StatefulWidget {
  const EditDeviceScreen({Key? key}) : super(key: key);

  @override
  State<EditDeviceScreen> createState() => _EditDeviceScreenState();
}

class _EditDeviceScreenState extends State<EditDeviceScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isNotChacked = true;
  DeviceType _deviceType = DeviceType.unknown;
  Device? _oldDevice;
  AppLocalizations? _stringRes;

  void _readData(BuildContext context) {
    _oldDevice = ModalRoute.of(context)!.settings.arguments as Device?;
    if (_oldDevice != null) {
      setState(() {
        _nameController.text = _oldDevice!.name;
        _descriptionController.text = _oldDevice!.description;
        _deviceType = _oldDevice!.deviceType();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _stringRes = AppLocalizations.of(context);
    if (_isNotChacked) {
      _isNotChacked = false;
      _readData(context);
    }

    return BlocListener<EditDeviceCubit, EditDeviceState>(
      listenWhen: (previous, current) => true,
      listener: (context, state) {
        if (state is EditDeviceInitial) {
          context.loaderOverlay.hide();
        } else if (state is EditDeviceSuccess) {
          context.loaderOverlay.hide();
          Navigator.pop(context, _stringRes!.device_editor_success_message);
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
              _stringRes!.device_editor,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_oldDevice != null) const SizedBox(height: 16),
                _deleteRow(),
                const SizedBox(height: 16),
                _buildEditText(
                    _stringRes!.device_name, _nameController, false, 20, false),
                const SizedBox(height: 16),
                _buildEditText(_stringRes!.device_description,
                    _descriptionController, true, 400, true),
                const SizedBox(height: 16),
                _buildDeviceTypePicker(),
                const SizedBox(height: 16),
                Center(
                  child: ButtonComponent(
                      text: _oldDevice == null
                          ? _stringRes!.add
                          : _stringRes!.save,
                      onPressed: _onButtonPressed),
                ),
              ],
            ),
          )),
    );
  }

  Widget _deleteRow() {
    if (_oldDevice == null) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            _onDeletePressed();
          },
          child: Container(
            padding: const EdgeInsets.only(top: 4, bottom: 4, right: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _onDeletePressed,
                ),
                Text(
                  _stringRes!.delete,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildDeviceTypePicker() {
    return Row(
      children: [
        Text(
          _stringRes!.device_type,
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(width: 16),
        DropdownButton<DeviceType>(
            style: Theme.of(context).textTheme.headline2,
            value: _deviceType,
            items: _buildDeviceTypeDropdownItems(),
            onChanged: _oldDevice != null
                ? null
                : (type) => {
                      setState(() {
                        _deviceType = type!;
                      })
                    }),
      ],
    );
  }

  List<DropdownMenuItem<DeviceType>> _buildDeviceTypeDropdownItems() {
    return [
      _getItem(DeviceType.unknown, _stringRes!.unknown_device),
      _getItem(DeviceType.ds18b20, _stringRes!.ds18b20)
    ];
  }

  DropdownMenuItem<DeviceType> _getItem(DeviceType type, String name) {
    return DropdownMenuItem<DeviceType>(
        value: type,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(name, style: Theme.of(context).textTheme.headline2),
        ));
  }

  Widget _buildEditText(String hint, TextEditingController controller,
      bool isLast, int length, bool multiline) {
    return TextField(
      maxLines: multiline ? null : 1,
      maxLength: length,
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
    );
  }

  void _addDevice() {
    context.read<EditDeviceCubit>().addDevice(
          Device(
              id: "",
              name: _nameController.text,
              description: _descriptionController.text,
              type: _deviceType.name,
              buttery: 0,
              userId: ''),
        );
  }

  void _onButtonPressed() {
    if (_oldDevice != null) {
      context.read<EditDeviceCubit>().updateDevice(
            _oldDevice!.copyWith(
              name: _nameController.text,
              description: _descriptionController.text,
            ),
          );
    } else {
      _addDevice();
    }
  }

  void _onDeletePressed() {
    context.read<EditDeviceCubit>().deleteDevice(_oldDevice!);
  }
}
