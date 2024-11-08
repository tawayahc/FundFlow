import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../repository/auth_repository.dart';
import '../models/user_model.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationBloc({required this.authenticationRepository})
      : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<AuthenticationLoginRequested>(_onLoginRequested);
    on<AuthenticationRegisterRequested>(_onRegisterRequested);
    on<AuthenticationLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    logger.d('AppStarted event received');
    emit(AuthenticationLoading());
    try {
      final String? token = await authenticationRepository.getStoredToken();
      if (token != null) {
        logger.d('Token found, user is authenticated');
        emit(Authenticated(token: token));
      } else {
        logger.e('No token found, user is unauthenticated');
        emit(Unauthenticated());
      }
    } catch (e) {
      logger.e('Error: $e');
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    AuthenticationLoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      final String token = await authenticationRepository.login(
        username: event.username,
        password: event.password,
      );
      emit(Authenticated(token: token));
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    AuthenticationRegisterRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      final String token = await authenticationRepository.register(
        email: event.email,
        password: event.password,
        username: event.username,
      );
      emit(Authenticated(token: token));
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      await authenticationRepository.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }
}
