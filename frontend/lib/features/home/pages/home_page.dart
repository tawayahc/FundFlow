// pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/features/auth/bloc/auth_bloc.dart';
import 'package:fundflow/features/auth/bloc/auth_state.dart';
import 'package:fundflow/features/auth/ui/login_page.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_event.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_event.dart';
import 'package:fundflow/features/home/bloc/profile/profile_bloc.dart';
import 'package:fundflow/features/home/bloc/profile/profile_event.dart';
import 'package:fundflow/features/home/repository/bank_repository.dart';
import 'package:fundflow/features/home/repository/category_repository.dart';
import 'package:fundflow/features/home/repository/profile_repository.dart';
import 'package:fundflow/features/home/ui/home_ui.dart';

class HomePage extends StatelessWidget {
  final PageController pageController;
  const HomePage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BankBloc(
            bankRepository: context.read<BankRepository>(),
          )..add(LoadBanks()),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(
            categoryRepository: context.read<CategoryRepository>(),
          )..add(LoadCategories()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            profileRepository: context.read<ProfileRepository>(),
          )..add(LoadProfile()),
        ),
      ],
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          } else if (state is AuthenticationFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: HomeUI(pageController: pageController,),
      ),
    );
  }
}
