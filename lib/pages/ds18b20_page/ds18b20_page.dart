import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ds18b20_cubit.dart';
import 'ds18b20_screen.dart';

class Ds18b20Page extends StatelessWidget {
  const Ds18b20Page({Key? key}) : super(key: key);
  static const String route = "/ds18b20";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>Ds18b20Cubit(), child: const Ds18b20Screen());
  }
}
