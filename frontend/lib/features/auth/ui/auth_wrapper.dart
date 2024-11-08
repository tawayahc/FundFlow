import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/features/home/pages/home_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return HomePage(); // Access user via Bloc in HomePage
        } else if (state is Unauthenticated || state is AuthInitial) {
          return const LoginPage();
        } else if (state is AuthenticationLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthenticationFailure) {
          return Scaffold(
            body: Center(child: Text('Error: ${state.error}')),
          );
        }
        return Container(); // Default case
      },
    );
  }
}
