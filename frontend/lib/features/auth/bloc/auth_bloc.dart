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
    on<AuthenticationRefreshRequested>(
        _onAuthenticationRefreshRequested); // New event handler
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
        final User user = await authenticationRepository.getCurrentUser();
        emit(Authenticated(token: token, user: user));
      } else {
        logger.e('No token found, user is unauthenticated');
        emit(Unauthenticated());
      }
    } catch (e) {
      logger.e('Error: $e');
      emit(AuthenticationFailure(error: e.toString()));
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
      final User user = await authenticationRepository.getCurrentUser();
      emit(Authenticated(token: token, user: user));
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
      final User user = await authenticationRepository.getCurrentUser();
      emit(Authenticated(token: token, user: user));
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

  // New event handler to refresh user data
  Future<void> _onAuthenticationRefreshRequested(
    AuthenticationRefreshRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      final String? token = await authenticationRepository.getStoredToken();
      if (token != null) {
        final User user = await authenticationRepository.getCurrentUser();
        emit(Authenticated(token: token, user: user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }
}
