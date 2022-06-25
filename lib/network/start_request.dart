import 'dart:async';
import 'dart:io';

import 'package:weather_app/network/model_response.dart';

class Network<T> {
  Future<Result<T>> startReqest(Function() request) async {
    try {
      T data = await request();
      return Success(data);
    } on SocketException {
      return Error<T>("Please, check your internet connection and try again.");
    } on TimeoutException {
      return Error<T>("Server not responding!");
    } catch (e) {
      return Error<T>(e.toString());
    }
  }
}
