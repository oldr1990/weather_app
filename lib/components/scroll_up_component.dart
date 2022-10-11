import 'package:flutter/material.dart';

class ScrollToUpComponent extends StatelessWidget {
  final Function() scrollToTop;
  const ScrollToUpComponent({Key? key, required this.scrollToTop}) : super(key: key);

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        onPressed: scrollToTop,
        child: const Icon(
          Icons.arrow_upward_rounded,
          color: Colors.white,
          size: 36,
        ),
      );
}
