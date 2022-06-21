import 'package:flutter/material.dart';
import 'package:weather_app/components/button_component.dart';

class ErrorComponent extends StatefulWidget {
  final VoidCallback onRetry;
  final String errorMessage;
  const ErrorComponent(
      {Key? key, required this.onRetry, required this.errorMessage})
      : super(key: key);

  @override
  State<ErrorComponent> createState() => _ErrorComponentState();
}

class _ErrorComponentState extends State<ErrorComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              size: 96,
              color: Colors.red,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(widget.errorMessage,
                style: Theme.of(context).textTheme.headline3),
            const SizedBox(height: 16),
            ButtonComponent(text: 'Повторить', onPressed: widget.onRetry)
          ],
        ),
      ),
    );
  }
}
