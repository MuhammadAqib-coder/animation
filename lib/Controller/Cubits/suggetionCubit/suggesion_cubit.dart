import 'package:animation_task/Controller/Cubits/suggetionCubit/suggestion_state.dart';
import 'package:animation_task/Controller/Repos/status_code.dart';
import 'package:animation_task/Controller/Repos/suggestion_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuggesionCubit extends Cubit<SuggesionState> {
  SuggesionCubit() : super(SuggesionInitialState());

  getSuggesionList(input) async {
    try {
      emit(SuggesionLoadingState());
      int response = await SuggestionRepo().suggestionList(input);
      if (response == 200) {
        emit(SuggesionLoadedState());
      } else if (response == StatusCode.socketException) {
        emit(SuggesionSocketExceptionState());
      } else {
        emit(SuggesionExceptionState());
      }
    } catch (e) {
      emit(SuggesionExceptionState());
    }
  }
}
