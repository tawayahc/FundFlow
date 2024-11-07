import 'package:flutter_bloc/flutter_bloc.dart';
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

  // Future<void> _onAppStarted(
  //   AppStarted event,
  //   Emitter<AuthenticationState> emit,
  // ) async {
  //   print('AppStarted event triggered');
  //   emit(AuthenticationLoading());
  //   try {
  //     final User? user = await authenticationRepository.getCurrentUser();
  //     if (user != null) {
  //       print('User is authenticated: ${user.name}');
  //       emit(Authenticated(user: user));
  //     } else {
  //       print('User is unauthenticated');
  //       emit(Unauthenticated());
  //     }
  //   } catch (e) {
  //     print('Error during AppStarted: $e');
  //     emit(Unauthenticated());
  //   }
  // }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    // Comment out the actual authentication logic for testing
    // emit(AuthenticationLoading());

    // Bypass the login check for testing purposes and emit an authenticated state
    emit(Authenticated(
        user: User(
      username: 'Test User',
      email: 'test@user.com',
    )));

    // Uncomment the below code when you want to restore the authentication logic
    // try {
    //   final User? user = await authenticationRepository.getCurrentUser();
    //   if (user != null) {
    //     emit(Authenticated(user: user));
    //   } else {
    //     emit(Unauthenticated());
    //   }
    // } catch (e) {
    //   emit(Unauthenticated());
    // }
  }

  Future<void> _onLoginRequested(
    AuthenticationLoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      final User user = await authenticationRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(user: user));
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
      final User user = await authenticationRepository.register(
        email: event.email,
        password: event.password,
        username: event.username,
      );
      emit(Authenticated(user: user));
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
