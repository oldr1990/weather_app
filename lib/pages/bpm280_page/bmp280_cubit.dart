import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../models/bmp280.dart';
import '../../models/device.dart';
import '../../models/request_data.dart';
import '../../network/firestore_repository.dart';
import '../../network/model_response.dart';

part 'bmp280_state.dart';

class Bmp280Cubit extends Cubit<Bmp280State> {
  final Device device;

  Bmp280Cubit(this.device) : super(Bmp280Loading());
  final FirestoreRepository repository = FirestoreRepository();
  RequestData request = RequestData("", true);
  List<BMP280> list = [];

  Future getData(bool isFirstLoading, {bool needShowLoading = true}) async {
    if (needShowLoading) emit(Bmp280Loading());
    request = request.copy(deviceId: device.id, newLoading: isFirstLoading);
    Result<List<BMP280>> result = await repository.getBmp280(request);
    if (result is Success) {
      result as Success<List<BMP280>>;
      if (kDebugMode) {
        print(result.value);
      }
      if (isFirstLoading) list.clear();
      if (result.value.isNotEmpty) {
        list.addAll(result.value);
      }
      if (list.length < 10 && result.value.isNotEmpty) {
        getData(false);
      } else {
        emit(Bmp280Success(_getListOfLists(list), result.value.isEmpty));
      }
    } else {
      result as Error<List<BMP280>>;
      emit(Bmp280Error(result.errorMessage ?? "Unexpected error"));
    }
  }

  List<List<BMP280>> _getListOfLists(List<BMP280> list) {
    List<List<BMP280>> majorList = [];
    List<BMP280> smallList = [];
    for (int i = 0; i < list.length; i++) {
      if (smallList.isNotEmpty && list[i].date.day != list[i - 1].date.day) {
        majorList.add(smallList.toList());
        smallList.clear();
      } else {
        smallList.add(list[i]);
      }
    }
    majorList.add(smallList.toList());
    return majorList.toList();
  }
}
