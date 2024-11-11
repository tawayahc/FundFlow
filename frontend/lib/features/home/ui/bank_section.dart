import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/bank_card.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';
import 'package:fundflow/features/manageBankAccount/ui/bank_account_page.dart';

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BankAccountPage(
                            bank: bank, bankColorMap: bankColorMap),
                      ),
                    );
                  },
                  child: BankCard(
                    bank: bank,
                    bankColorMap: bankColorMap,
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

Map<String, Color> bankColorMap = {
  'ธนาคารกสิกรไทย': Colors.green,
  'ธนาคารกรุงไทย': Colors.blue,
  'ธนาคารไทยพาณิชย์': Colors.purple,
  'ธนาคารกรุงเทพ': Colors.lightBlue,
  'ธนาคารกรุงศรี': const Color(0xFFffe000),
};
