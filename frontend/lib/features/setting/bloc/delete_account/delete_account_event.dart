part of 'delete_account_bloc.dart';

abstract class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object> get props => [];
}

class SubmitDeleteAccountEvent extends DeleteAccountEvent {
  final String password;

  const SubmitDeleteAccountEvent(this.password);

  @override
  List<Object> get props => [password];
}
