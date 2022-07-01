part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Device> devices;

  HomeSuccess(this.devices);
}

class HomeLoading extends HomeState {}

class HomeFailure extends HomeState {
  final Error error;

  HomeFailure({required this.error});
}
