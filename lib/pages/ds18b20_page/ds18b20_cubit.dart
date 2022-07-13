import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/device.dart';
import '../../models/ds18b20.dart';
import '../../network/firestore_repository.dart';
import '../../network/model_response.dart';

part 'ds18b20_state.dart';

class Ds18b20Cubit extends Cubit<Ds18b20State> {
  Ds18b20Cubit() : super(Ds18b20Loading());
  final FirestoreRepository repository = FirestoreRepository();

  Future getDs18b20() async {
    emit(Ds18b20Loading());
    Result<List<Ds18b20>> result = await repository.getDs18b20(Device(
        id: '', name: '', description: '', type: '', buttery: 0, userId: ''));
    if (result is Success) {
      result as Success<List<Ds18b20>>;
      emit(Ds18b20Success(result.value));
    } else {
      result as Error<List<Ds18b20>>;
      emit(Ds18b20Error(result));
    }
  }
}
