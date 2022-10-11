part of 'edit_device_cubit.dart';

@immutable
abstract class EditDeviceState {}

class EditDeviceNormal extends EditDeviceState {}

class EditDeviceLoading extends EditDeviceState {}

class EditDeviceSuccess extends EditDeviceState {}

class EditDeviceFailure extends EditDeviceState {
  final String errorMessage;

  EditDeviceFailure(this.errorMessage);
}
