import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_app/models/ds18b20_request.dart';

import '../../models/ds18b20.dart';
import '../../network/firestore_repository.dart';
import '../../network/model_response.dart';

part 'ds18b20_state.dart';

class Ds18b20Cubit extends Cubit<Ds18b20State> {
  Ds18b20Cubit() : super(Ds18b20Loading());
  final FirestoreRepository repository = FirestoreRepository();
  List<Ds18b20> list = <Ds18b20>[];
  Ds18b20Request request =
      Ds18b20Request(DateTime.now().millisecondsSinceEpoch ~/ 1000, "", true);

  Future getDs18b20(
      String deviceid, bool firstLoading, bool needShowLoading) async {
    if (needShowLoading) emit(Ds18b20Loading());
    if (firstLoading || request.deviceId.isEmpty) {
      request = request.copy(
          deviceId: deviceid,
          newLoading: true,
          lastLoadedDate: _getTimeInSeconds());
    }
    Result<List<Ds18b20>> result = Success(getTestList()); //await repository.getDs18b20(request);
    if (result is Success) {
      result as Success<List<Ds18b20>>;
      if (kDebugMode) {
        print(result.value);
      }
      if (firstLoading) list.clear();
      request = request.copy(lastLoadedDate: request.getDayBeforeLastLoaded());
      if (firstLoading || result.value.isEmpty) {
        getDs18b20(deviceid, false, needShowLoading);
        return;
      }
      list.addAll(result.value);
      list.sort((a, b) => a.date.compareTo(b.date));
      emit(Ds18b20Success(list));
    } else {
      result as Error<List<Ds18b20>>;
      emit(Ds18b20Error(result));
    }
  }

  int _getTimeInSeconds() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  List<Ds18b20> getTestList() {
    List<Ds18b20> list = [];
    DateTime currentDate = DateTime.now();
    double currentTemp = 20.0;
    for (int i = 1; i < 20; i++) {
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
}
