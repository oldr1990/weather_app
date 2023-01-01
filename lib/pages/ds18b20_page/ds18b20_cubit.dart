import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_app/models/request_data.dart';

import '../../models/device.dart';
import '../../models/ds18b20.dart';
import '../../network/firestore_repository.dart';
import '../../network/model_response.dart';

part 'ds18b20_state.dart';

class Ds18b20Cubit extends Cubit<Ds18b20State> {
  final Device device;

  Ds18b20Cubit(this.device) : super(Ds18b20Loading());
  final FirestoreRepository repository = FirestoreRepository();
  List<Ds18b20> list = [];
  RequestData request = RequestData("", true);

  Future getDs18b20(bool firstLoading, {bool needShowLoading = true}) async {
    if (needShowLoading) emit(Ds18b20Loading());
    request = request.copy(deviceId: device.id, newLoading: firstLoading);
    Result<List<Ds18b20>> result = await repository.getDs18b20(request);
    if (result is Success) {
      result as Success<List<Ds18b20>>;
      if (kDebugMode) {
        print(result.value);
      }
      if (firstLoading) list.clear();
      list.addAll(result.value);
      if (list.length < 10 && result.value.isNotEmpty) {
        getDs18b20(false);
      } else {
        emit(Ds18b20Success(_getListOfLists(list), result.value.isEmpty));
      }
    } else {
      result as Error<List<Ds18b20>>;
      emit(Ds18b20Error(result));
    }
  }

  List<Ds18b20> getTestList() {
    List<Ds18b20> list = [];
    DateTime currentDate = DateTime.now();
    double currentTemp = 20.0;
    for (int i = 1; i < 100; i++) {
      list.add(Ds18b20(date: currentDate, temperature: currentTemp));
      currentDate = currentDate.subtract(const Duration(minutes: 10));
      if (currentTemp >= 30) {
        currentTemp--;
      } else if (currentTemp <= 15) {
        currentTemp++;
      } else {
        currentTemp += Random().nextInt(3) - 1;
      }
    }
    return list;
  }

  List<List<Ds18b20>> _getListOfLists(List<Ds18b20> list) {
    List<List<Ds18b20>> majorList = [];
    List<Ds18b20> smallList = [];
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
