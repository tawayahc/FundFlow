import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fundflow/features/setting/models/change_email_request.dart';
import 'package:fundflow/features/setting/repository/settings_repository.dart';

part 'change_email_event.dart';
part 'change_email_state.dart';

class ChangeEmailBloc extends Bloc<ChangeEmailEvent, ChangeEmailState> {
  final SettingsRepository repository;

  ChangeEmailBloc({required this.repository}) : super(ChangeEmailInitial()) {
    on<SubmitChangeEmailEvent>((event, emit) async {
      emit(ChangeEmailLoading());
      try {
        await repository
            .changeEmail(ChangeEmailRequest(newEmail: event.newEmail));
        emit(ChangeEmailSuccess());
      } catch (e) {
        emit(ChangeEmailFailure(error: e.toString()));
      }
    });
  }
}
