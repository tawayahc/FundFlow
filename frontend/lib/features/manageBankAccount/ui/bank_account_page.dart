import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/home/bank_balance_box.dart';
import 'package:fundflow/core/widgets/management/delete_transaction_page.dart';
import 'package:fundflow/core/widgets/management/transfer_transaction_card.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_event.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_bloc.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_event.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_state.dart';
import 'package:fundflow/features/home/pages/bank/edit_bank_page.dart';
import '../../home/models/transaction.dart';
import '../../../core/themes/app_styles.dart';
import '../../../core/widgets/management/transaction_card.dart';
import '../../home/models/category.dart';
import '../../home/models/bank.dart';


class BankAccountPage extends StatefulWidget {
  final Bank bank;

  const BankAccountPage({super.key, required this.bank});

  @override
  State<StatefulWidget> createState() => _BankAccountPageState();
}

class _BankAccountPageState extends State<BankAccountPage>
    with SingleTickerProviderStateMixin {
  String _type = 'income';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = ['income', 'expense', 'transfer'].indexOf(_type);

    _tabController.addListener(() {
      setState(() {
        _type = ['income', 'expense', 'transfer'][_tabController.index];
        if (_type == 'transfer') {
          context.read<BankBloc>().add(LoadTransfers());
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<TransactionBloc>().add(LoadTransactions());
    Color color = bankColorMap[widget.bank.bank_name] ?? Colors.grey;

    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavBar(),
                ),
              );
            },
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final updatedBank = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditBankPage(bank: widget.bank),
                  ),
                );

                if (updatedBank != null) {
                  // Handle updated bank
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: color,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bank.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.bank.bank_name,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BankBalanceBox(color: color, bank: widget.bank, date: '00:00 น.'),
              const SizedBox(height: 30),
              const Text(
                'ประวัติการทำรายการ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, transactionState) {
                    if (transactionState is TransactionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (transactionState is TransactionsLoaded) {
                      final bankTransactions = transactionState.transactions
                          .where((transaction) =>
                              transaction.bankId == widget.bank.id)
                          .toList();

                      final sortedTransactions = List.from(bankTransactions)
                        ..sort((a, b) => DateTime.parse(b.createdAt)
                            .compareTo(DateTime.parse(a.createdAt)));

                      final filteredTransactions = sortedTransactions
                          .where((transaction) => transaction.type == _type)
                          .toList();

                      return ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];

                          return GestureDetector(
                            onTap: () {
                              _showDeleteTransactionModal(
                                  context, transaction);
                            },
                            child: TransactionCard(transaction: transaction),
                          );
                        },
                      );
                    } else if (transactionState is TransactionsLoadError) {
                      return Center(child: Text(transactionState.message));
                    } else {
                      return const Center(child: Text('Unknown error'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteTransactionModal(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54, // โปร่งแสง
      builder: (BuildContext context) {
        return DeleteTransactionPage(transaction: transaction);
      },
    );
  }
}

Map<String, Color> bankColorMap = {
  'ธนาคารกสิกรไทย': Colors.green,
  'ธนาคารกรุงไทย': Colors.blue,
  'ธนาคารไทยพาณิชย์': Colors.purple,
  'ธนาคารกรุงเทพ': const Color.fromARGB(255, 10, 35, 145),
  'ธนาคารกรุงศรีอยุธยา': const Color(0xFFffe000),
  'ธนาคารออมสิน': Colors.pink,
  'ธนาคารธนชาต': const Color(0xFFF68B1F),
  'ธนาคารเกียรตินาคิน': const Color(0xFF004B87),
  'ธนาคารซิตี้แบงก์': const Color(0xFF1E90FF),
  'ธนาคารเมกะ': const Color(0xFF3B5998),
};
