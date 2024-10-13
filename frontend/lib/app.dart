import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/auth/ui/auth_wrapper.dart';
import 'features/auth/ui/login_page.dart';
import 'features/auth/ui/registeration_page.dart';
import 'features/auth/ui/forget_page_1.dart';
import 'features/auth/ui/forget_page_2.dart';
import 'features/auth/ui/forget_page_3.dart';
import 'features/home/ui/home_page.dart';

class MyApp extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  const MyApp({Key? key, required this.authenticationRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        )..add(AppStarted()), // Initialize authentication state
        child: MaterialApp(
          title: 'FundFlow',
          theme: AppTheme.lightTheme, // Apply the light theme
          darkTheme: AppTheme.darkTheme, // Apply the dark theme (optional)
          themeMode: ThemeMode.system, // Use system theme mode
          home: AuthenticationWrapper(),
          routes: {
            '/login': (context) => LoginPage(),
            '/register': (context) => RegistrationPage(),
            '/forget1': (context) => ForgetPage(),
            '/forget2': (context) => VerificationPage(),
            '/forget3': (context) => ResetPasswordPage(),
            '/home': (context) => HomePage(), // No need to pass user object
            // Add other routes here
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
    // NOTE: Uncomment this block of code to test the page
    //   child: BlocProvider<AuthenticationBloc>(
    //     create: (context) => AuthenticationBloc(
    //       authenticationRepository: authenticationRepository,
    //     )..add(AppStarted()), // Ensure you have an AppStarted event
    //     child: MaterialApp(
    //       title: 'FundFlow',
    //       theme: AppTheme.lightTheme, // Apply the theme here
    //       home: LoginPage(), // NOTE: Change this to the page you want to test
    //       routes: {
    //         '/login': (context) => LoginPage(),
    //         '/register': (context) => RegistrationPage(),
    //         '/home': (context) => HomePage(),
    //         // Add other routes here
    //       },
    //       debugShowCheckedModeBanner: false,
    //     ),
    //   ),
    // );
  }
}
