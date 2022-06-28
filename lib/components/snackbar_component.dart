import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        message,
        style: Theme.of(context).textTheme.headline2,
      ),
    ),
    backgroundColor: Colors.black38,
    duration: const Duration(seconds: 3),
  ));
}
