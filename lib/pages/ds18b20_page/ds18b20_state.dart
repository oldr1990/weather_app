part of 'ds18b20_cubit.dart';

@immutable
abstract class Ds18b20State {}

class Ds18b20Loading extends Ds18b20State {}

class Ds18b20Error extends Ds18b20State {
  final Error message;

  Ds18b20Error(this.message);
}

class Ds18b20Success extends Ds18b20State {
  final List<Ds18b20> device;
  final bool isEnd;

  Ds18b20Success(this.device, this.isEnd);
}
