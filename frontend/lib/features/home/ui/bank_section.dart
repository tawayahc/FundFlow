import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/bank_card.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';
import 'package:fundflow/features/home/models/bank.dart';
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
  'ธนาคารกสิกรไทย': Colors.green, // Kasikorn Bank
  'ธนาคารกรุงไทย': Colors.blue, // Krung Thai Bank
  'ธนาคารไทยพาณิชย์': Colors.purple, // Siam Commercial Bank
  'ธนาคารกรุงเทพ': const Color.fromARGB(255, 10, 35, 145), // Bangkok Bank
  'ธนาคารกรุงศรีอยุธยา': const Color(0xFFffe000), // Krungsri (Bank of Ayudhya)
  'ธนาคารออมสิน': Colors.pink, // Government Savings Bank
  'ธนาคารธนชาต': const Color(0xFFF68B1F), // Thanachart Bank
  'ธนาคารเกียรตินาคิน': const Color(0xFF004B87), // Kiatnakin Bank
  'ธนาคารซิตี้แบงก์': const Color(0xFF1E90FF), // Citibank
  'ธนาคารเมกะ': const Color(0xFF3B5998), // Mega Bank
};
