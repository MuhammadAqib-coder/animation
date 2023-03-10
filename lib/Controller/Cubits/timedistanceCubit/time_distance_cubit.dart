import 'package:animation_task/Controller/Cubits/timedistanceCubit/time_distance_state.dart';
import 'package:animation_task/Controller/Repos/status_code.dart';
import 'package:animation_task/Controller/Repos/time_distance_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeDistanceCubit extends Cubit<TimeDistanceState> {
  TimeDistanceCubit() : super(TimeDistanceInitialState());

  getTimeDistance(endDestination, startDestination) async {
    try {
      emit(TimeDistanceLoadingState());
      int response = await TimeDistanceRepo()
          .getTimedistance(endDestination, startDestination);
      if (response == 200) {
        emit(TimeDistanceLoadedState());
      } else if (response == StatusCode.socketException) {
        emit(TimeDistanceSocketExceptionState());
      } else {
        emit(TimeDistanceExceptionState());
      }
    } catch (e) {
      emit(TimeDistanceExceptionState());
    }
  }
}
