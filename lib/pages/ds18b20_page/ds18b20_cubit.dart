import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ds18b20_state.dart';

class Ds18b20Cubit extends Cubit<Ds18b20State> {
  Ds18b20Cubit() : super(Ds18b20Initial());
}
