import 'package:equatable/equatable.dart';
import '../models/user_model.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthInitial extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthenticationState {
  final String token;

  const Authenticated({required this.token});

  @override
  List<Object?> get props => [token];
}

class Unauthenticated extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationFailure extends AuthenticationState {
  final String error;

  const AuthenticationFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
