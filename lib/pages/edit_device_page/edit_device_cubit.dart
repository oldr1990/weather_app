import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/models/device.dart';
import 'package:weather_app/network/firestore_repository.dart';
import 'package:weather_app/network/model_response.dart';

part 'edit_device_state.dart';

class EditDeviceCubit extends Cubit<EditDeviceState> {
  EditDeviceCubit() : super(EditDeviceInitial());
  final FirestoreRepository repository = FirestoreRepository();

  Future addDevice(Device device) async {
    emit(EditDeviceLoading());
    Result<bool> result = await repository.addDevice(device);
    _resultHandler(result);
  }

  Future updateDevice(Device device) async {
    emit(EditDeviceLoading());
    Result<bool> result = await repository.updateDevice(device);
    _resultHandler(result);
  }

  Future deleteDevice(Device device) async {
    emit(EditDeviceLoading());
    Result<bool> result = await repository.deleteDevice(device);
    _resultHandler(result);
  }

  void _resultHandler(Result<bool> result) {
    if (result is Success) {
      result as Success<bool>;
      emit(EditDeviceSuccess());
    } else {
      result as Error<bool>;
      emit(EditDeviceFailure(result.errorMessage!));
    }
  }
}
