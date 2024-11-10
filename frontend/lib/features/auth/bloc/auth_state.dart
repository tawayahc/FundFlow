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
  final User user; // Added User object

  const Authenticated({required this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
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
