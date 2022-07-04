import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/components/components.dart';
import 'package:weather_app/models/device.dart';
import 'package:weather_app/models/device_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceComponent extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback editTap;
  final Device device;

  const DeviceComponent(
      {Key? key,
      required this.onTap,
      required this.device,
      required this.editTap})
      : super(key: key);

  @override
  State<DeviceComponent> createState() => _DeviceComponentState();
}

class _DeviceComponentState extends State<DeviceComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameRow(),
                      const SizedBox(height: 8),
                      Text(
                        widget.device.description,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 8),
                      _buildIdRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildNameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              _buildIcon(widget.device.deviceType()),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.device.name,
                  style: Theme.of(context).textTheme.headline2,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            widget.editTap();
          },
        ),
      ],
    );
  }

  Widget _buildIdRow() {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: widget.device.id));
        showSnackbar(context, AppLocalizations.of(context)!.copied);
      },
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4.0),
          child: Text("ID: ${widget.device.id}",
              style: Theme.of(context).textTheme.bodyText1)),
    );
  }

  Widget _buildIcon(DeviceType type) {
    switch (type) {
      case DeviceType.ds18b20:
        return const Icon(
          Icons.thermostat,
          color: Colors.amber,
          size: 40,
        );
      case DeviceType.unknown:
        return const Icon(
          Icons.device_unknown,
          color: Colors.grey,
          size: 40,
        );
    }
  }
}
