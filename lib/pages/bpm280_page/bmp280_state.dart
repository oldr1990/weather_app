part of 'bmp280_cubit.dart';

@immutable
abstract class Bmp280State {}

class Bmp280Loading extends Bmp280State {}

class Bmp280Error extends Bmp280State {
  final String message;

  Bmp280Error(this.message);
}

class Bmp280Success extends Bmp280State {
  final List<List<BMP280>> devices;
  final bool isEnd;

  Bmp280Success(this.devices, this.isEnd);

}
