// lib/features/home/ui/home_page.dart
// Example of a simple home page widget that displays user information and navigation buttons.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/themes/app_styles.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/ui/login_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building HomePage');
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          print('User authenticated: ${user.name}');
          return Scaffold(
            appBar: AppBar(
              title: Text('Welcome, ${user.name}'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    // Trigger logout event
                    context
                        .read<AuthenticationBloc>()
                        .add(AuthenticationLogoutRequested());
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Card(
                      child: ListTile(
                        leading:
                            const Icon(Icons.person, color: AppColors.primary),
                        title: const Text('Name'),
                        subtitle: Text(user.name),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading:
                            const Icon(Icons.email, color: AppColors.primary),
                        title: const Text('Email'),
                        subtitle: Text(user.email),
                      ),
                    ),
                    // Add more user details if needed
                    const SizedBox(height: AppSpacing.large),
                    // Navigation buttons
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/account_management');
                      },
                      icon: const Icon(Icons.account_balance),
                      label: const Text('Manage Accounts'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppBorders.medium,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/pocket_management');
                      },
                      icon: const Icon(Icons.category),
                      label: const Text('Manage Pockets'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppBorders.medium,
                        ),
                      ),
                    ),
                    // Add more buttons as needed
                  ],
                ),
              ),
            ),
          );
        } else if (state is AuthenticationLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is Unauthenticated) {
          // Redirect to the login page
          Future.microtask(() => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage())));
          return const SizedBox
              .shrink(); // Return an empty widget while redirecting
        } else {
          // If not authenticated, redirect to login or show a message
          return const Scaffold(
            body: Center(child: Text('User not authenticated')),
          );
        }
      },
    );
  }
}
