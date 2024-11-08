import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'features/auth/repository/auth_repository.dart';

void main() {
  Bloc.observer = CustomBlocObserver();
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  runApp(MyApp(authenticationRepository: authenticationRepository));
}

class CustomBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('Bloc Event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('Bloc Transition: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('Bloc Error: $error');
  }
}
