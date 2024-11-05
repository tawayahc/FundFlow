// pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_event.dart';
import 'package:fundflow/features/home/bloc/expense/expense_bloc.dart';
import 'package:fundflow/features/home/bloc/expense/expense_event.dart';
import 'package:fundflow/features/home/bloc/profile/profile_bloc.dart';
import 'package:fundflow/features/home/bloc/profile/profile_event.dart';
import 'package:fundflow/features/home/repository/bank_repository.dart';
import 'package:fundflow/features/home/repository/expense_repository.dart';
import 'package:fundflow/features/home/repository/profile_repository.dart';
import 'package:fundflow/features/home/ui/home_ui.dart'; // Import the new HomeUI

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          create: (context) => ExpenseBloc(
            expenseRepository: context.read<ExpenseRepository>(),
          )..add(LoadExpenses()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            profileRepository: context.read<ProfileRepository>(),
          )..add(LoadProfile()),
        ),
      ],
      child: const HomeUI(), // Use the HomeUI widget here
    );
  }
}