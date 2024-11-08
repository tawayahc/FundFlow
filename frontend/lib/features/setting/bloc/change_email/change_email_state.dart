part of 'change_email_bloc.dart';

abstract class ChangeEmailState extends Equatable {
  const ChangeEmailState();

  @override
  List<Object> get props => [];
}

class ChangeEmailInitial extends ChangeEmailState {}

class ChangeEmailLoading extends ChangeEmailState {}

class ChangeEmailSuccess extends ChangeEmailState {}

class ChangeEmailFailure extends ChangeEmailState {
  final String error;

  const ChangeEmailFailure({required this.error});

  @override
  List<Object> get props => [error];
}
