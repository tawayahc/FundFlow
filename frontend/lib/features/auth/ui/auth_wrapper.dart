import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/navBar/main_layout.dart';
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
          // final userProfile = state.userProfile; // Access userProfile
          // NOTE: we can pass user profile to home page
          return const BottomNavBar();
        } else if (state is Unauthenticated || state is AuthInitial) {
          return const LoginPage();
        } else if (state is AuthenticationLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const LoginPage();
      },
    );
  }
}
