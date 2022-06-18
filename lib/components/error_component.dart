import 'package:flutter/material.dart';

class ErrorComponent extends StatefulWidget {
  final Function onRetry;
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
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.error,
            size: 32,
            color: Colors.red,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(widget.errorMessage,
              style: Theme.of(context).textTheme.headline1),
        ],
      ),
    );
  }
}
