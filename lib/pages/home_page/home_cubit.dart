import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/models/device.dart';
import 'package:weather_app/network/firebase_firestore_service.dart';
import 'package:weather_app/network/model_response.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final FirebaseFirestoreService firebaseService = FirebaseFirestoreService();

  Future loadDevicesList() async {
    emit(HomeLoading());
    Result<List<Device>> result = await firebaseService.getDevices();
    if (result is Success) {
      result as Success<List<Device>>;
      emit(HomeSuccess(result.value));
    } else {
      result as Error<List<Device>>;
      emit(HomeFailure(errorMessage: result.errorMessage));
    }
  }
}
