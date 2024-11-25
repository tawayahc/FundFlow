import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_bloc.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_event.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_state.dart';
import 'package:intl/intl.dart';
import 'package:fundflow/features/home/models/transaction.dart';

class DeleteTransactionPage extends StatelessWidget {
  final Transaction transaction;

  const DeleteTransactionPage({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the date
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final formattedDate =
        dateFormatter.format(DateTime.parse(transaction.createdAt));

    // Format the amount
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '', // No currency symbol
      decimalDigits: 2,
    );

    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionDeleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
          );
        } else if (state is TransactionsLoadError) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(state.message)),
          // );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Memo: ${transaction.memo}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Amount: ${formatter.format(transaction.amount)}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Type: ${transaction.type}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Bank: ${transaction.bankName}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Created At: $formattedDate',
                  style: const TextStyle(fontSize: 18)),
              Center(
                child: TextButton(
                  onPressed: () {
                    BlocProvider.of<TransactionBloc>(context)
                        .add(DeleteTransaction(transactionId: transaction.id));
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Color(0xFFFF5C5C),
                      ),
                      Text(
                        'ลบธนาคาร',
                        style: TextStyle(
                          color: Color(0xFFFF5C5C),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
