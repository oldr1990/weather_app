import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather_app/components/components.dart';
import 'package:weather_app/models/device.dart';
import 'package:weather_app/models/device_type.dart';
import 'package:weather_app/pages/edit_device_page/edit_device_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditDeviceScreen extends StatefulWidget {
  const EditDeviceScreen({Key? key, required this.oldDevice}) : super(key: key);
  final Device? oldDevice;

  @override
  State<EditDeviceScreen> createState() => _EditDeviceScreenState();
}

class _EditDeviceScreenState extends State<EditDeviceScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isNotChacked = true;
  DeviceType _deviceType = DeviceType.unknown;
  AppLocalizations? _stringRes;

  void _readData(BuildContext context) {
    if (widget.oldDevice != null) {
      setState(() {
        _nameController.text = widget.oldDevice!.name;
        _descriptionController.text = widget.oldDevice!.description;
        _deviceType = widget.oldDevice!.deviceType();
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
        if (state is EditDeviceNormal) {
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
            actions: widget.oldDevice == null
                ? null
                : <Widget>[
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: _onDeletePressed,
                    )
                  ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      text: widget.oldDevice == null
                          ? _stringRes!.add
                          : _stringRes!.save,
                      onPressed: _onSavePressed),
                ),
              ],
            ),
          )),
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
        Expanded(
          child: DropdownButton<DeviceType>(
              isExpanded: true,
              style: Theme.of(context).textTheme.headline2,
              value: _deviceType,
              items: _buildDeviceTypeDropdownItems(),
              onChanged: widget.oldDevice != null
                  ? null
                  : (type) => {
                        setState(() {
                          _deviceType = type!;
                        })
                      }),
        ),
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
          child: Text(
            name,
            style: Theme.of(context).textTheme.headline3,
          ),
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
              battery: 100,
              userId: ''),
        );
  }

  void _onSavePressed() {
    if (widget.oldDevice != null) {
      context.read<EditDeviceCubit>().updateDevice(
            widget.oldDevice!.copyWith(
              name: _nameController.text,
              description: _descriptionController.text,
            ),
          );
    } else {
      _addDevice();
    }
  }

  void _onDeletePressed() {
    context.read<EditDeviceCubit>().deleteDevice(widget.oldDevice!);
  }
}
