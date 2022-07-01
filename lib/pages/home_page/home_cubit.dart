import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/models/device.dart';
import 'package:weather_app/network/firestore_repository.dart';
import 'package:weather_app/network/model_response.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final FirestoreRepository repository = FirestoreRepository();

  Future loadDevicesList() async {
    emit(HomeLoading());
    Result<List<Device>> result = await repository.getDevices();
    if (result is Success) {
      result as Success<List<Device>>;
      emit(HomeSuccess(result.value));
    } else {
      result as Error<List<Device>>;
      emit(HomeFailure(error: result));
    }
  }
}
