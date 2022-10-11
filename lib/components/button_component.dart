import 'package:flutter/material.dart';

class ButtonComponent extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  const ButtonComponent({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black12)),
      child: Text(
        widget.text,
        style: Theme.of(context).textTheme.headline2,
      ),
      onPressed: widget.onPressed,
    );
  }
}
