import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        style: Theme.of(context).textTheme.headline3,
      ),
    ),
    backgroundColor: Colors.black38,
    duration: const Duration(seconds: 3),
  ));
}
