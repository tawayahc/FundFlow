import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fundflow/features/setting/models/delete_account_request.dart';
import 'package:fundflow/features/setting/repository/settings_repository.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final SettingsRepository repository;

  DeleteAccountBloc({required this.repository})
      : super(DeleteAccountInitial()) {
    on<SubmitDeleteAccountEvent>((event, emit) async {
      emit(DeleteAccountLoading());
      try {
        await repository
            .deleteAccount(DeleteAccountRequest(password: event.password));
        emit(DeleteAccountSuccess());
      } catch (e) {
        emit(DeleteAccountFailure(error: e.toString()));
      }
    });
  }
}
