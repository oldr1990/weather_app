import 'package:flutter/material.dart';
import 'package:weather_app/models/device.dart';
import 'package:weather_app/models/device_type.dart';

class DeviceComponent extends StatefulWidget {
  final VoidCallback onTap;
  final Device device;
  const DeviceComponent({Key? key, required this.onTap, required this.device})
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
              child: Row(
                children: [
                  _buildIcon(widget.device.deviceType()),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.device.name,
                              style: Theme.of(context).textTheme.headline2),
                          Text(widget.device.description,
                              style: Theme.of(context).textTheme.bodyText1),
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
