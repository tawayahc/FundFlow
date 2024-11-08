part of 'change_email_bloc.dart';

abstract class ChangeEmailEvent extends Equatable {
  const ChangeEmailEvent();

  @override
  List<Object> get props => [];
}

class SubmitChangeEmailEvent extends ChangeEmailEvent {
  final String newEmail;

  const SubmitChangeEmailEvent(this.newEmail);

  @override
  List<Object> get props => [newEmail];
}
