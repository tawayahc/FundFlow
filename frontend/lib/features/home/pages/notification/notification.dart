import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/notification/transaction_card.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_bloc.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_event.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_state.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<TransactionBloc>().add(LoadTransactions());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionsLoaded) {
            // Sort transactions by date in descending order (newest first)
            final sortedTransactions = List.from(state.transactions)
              ..sort((a, b) => DateTime.parse(b.createdAt)
                  .compareTo(DateTime.parse(a.createdAt)));

            return ListView.builder(
              itemCount: sortedTransactions.length,
              itemBuilder: (context, index) {
                final transaction = sortedTransactions[index];
                return TransactionCard(transaction: transaction);
              },
            );
          } else if (state is TransactionsLoadError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unknown error'));
          }
        },
      ),
    );
  }
}
