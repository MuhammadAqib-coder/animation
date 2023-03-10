import 'package:animation_task/Controller/Repos/near_search_repo.dart';
import 'package:animation_task/Controller/Repos/status_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'near_search_state.dart';

class NearSearchCubit extends Cubit<NearSearchState> {
  NearSearchCubit() : super(NearSearchInitialState());

  getNearPlaces(type, lat, lng) async {
    try {
      emit(NearSearchLoadingState());
      int response = await NearSearchRepo().getNearPlaces(type, lat, lng);
      if (response == 200) {
        emit(NearSearchLoadedState());
      } else if (response == StatusCode.socketException) {
        emit(NearSearchSocketExceptionState());
      } else {
        emit(NearSearchExceptionState());
      }
    } catch (e) {
      emit(NearSearchExceptionState());
    }
  }
}
