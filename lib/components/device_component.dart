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
                    _buildBottomRow(),
                  ],
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

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
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
        ),
        _batteryIndicator(_getProcentage(widget.device.battery))
      ],
    );
  }

  int _getProcentage(int level) {
    if (level > 100) return 100;
    if (level < 0) return 0;
    return level;
  }

  Widget _batteryIndicator(int batteryLevel) => Row(
        children: [
          SizedBox(
            width: 50,
            height: 24,
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                )),
                Positioned(
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    width: batteryLevel / 2,
                    decoration: BoxDecoration(
                      color: _getColor(batteryLevel),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(3.0)),
                    ),
                  ),
                ),
                Center(child: Text(batteryLevel.toString() + "%")),
              ],
            ),
          ),
          Container(
            width: 3,
            height: 8,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(1.0))),
          )
        ],
      );

  Color _getColor(int battery) {
    if (battery >= 75) return Colors.green.shade800;
    if (battery >= 50) return const Color.fromARGB(255, 104, 121, 5);
    if (battery >= 25) return Colors.orange.shade800;
    return Colors.red.shade800;
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
