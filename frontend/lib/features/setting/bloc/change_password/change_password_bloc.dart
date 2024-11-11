import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fundflow/features/setting/models/change_password_request.dart';
import 'package:fundflow/features/setting/repository/settings_repository.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final SettingsRepository repository;

  ChangePasswordBloc({required this.repository})
      : super(ChangePasswordInitial()) {
    on<SubmitChangePasswordEvent>((event, emit) async {
      emit(ChangePasswordLoading());
      try {
        await repository.changePassword(ChangePasswordRequest(
          oldPassword: event.oldPassword,
          newPassword: event.newPassword,
        ));
        emit(ChangePasswordSuccess());
      } catch (e) {
        emit(ChangePasswordFailure(error: e.toString()));
      }
    });
  }
}
