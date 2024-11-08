import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AppStarted extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class AuthenticationLoginRequested extends AuthenticationEvent {
  final String username;
  final String password;

  const AuthenticationLoginRequested({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

class AuthenticationRegisterRequested extends AuthenticationEvent {
  final String email;
  final String password;
  final String username;

  const AuthenticationRegisterRequested({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object?> get props => [email, password, username];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}
