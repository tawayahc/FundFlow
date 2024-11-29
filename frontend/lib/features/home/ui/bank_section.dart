import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/bank_card.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';
import 'package:fundflow/features/home/models/bank.dart';
import 'package:fundflow/features/home/pages/bank/bank_account_page.dart';

class BankSection extends StatelessWidget {
  const BankSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankBloc, BankState>(
      builder: (context, state) {
        if (state is BanksLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BanksLoaded) {
          List<Bank> sortedBanks = List.from(state.banks)
            ..sort((a, b) => a.id.compareTo(b.id));
          return SizedBox(
            height: 105,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.banks.length,
              itemBuilder: (context, index) {
                final bank = sortedBanks[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BankAccountPage(bank: bank)),
                    );
                  },
                  child: BankCard(
                    bank: bank,
                  ),
                );
              },
            ),
          );
        } else if (state is BankError) {
          return const Text('Failed to load banks');
        } else {
          return const Center(child: Text('Unknown error'));
        }
      },
    );
  }
}
