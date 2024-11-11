import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/bank_card.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';

class BankSection extends StatelessWidget {
  const BankSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankBloc, BankState>(
      builder: (context, state) {
        if (state is BanksLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BanksLoaded) {
          return SizedBox(
            height: 105,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.banks.length,
              itemBuilder: (context, index) {
                final bank = state.banks[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/home');
                  },
                    child: BankCard(bank: bank)); // Use BankCard from separate file
              },
            ),
          );
        } else {
          return const Center(child: Text('Error loading banks'));
        }
      },
    );
  }
}
