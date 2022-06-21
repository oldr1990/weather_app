import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/models/device.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
}
