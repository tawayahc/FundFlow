// features/categorized/ui/categorized_summary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/overview/bloc/categorized/categorized_bloc.dart';
import 'package:fundflow/features/overview/bloc/categorized/categorized_state.dart';
import 'package:fundflow/features/overview/model/transaction_all_model.dart';

class CategorizedSummaryScreen extends StatelessWidget {
  final String categoryName;

  const CategorizedSummaryScreen({Key? key, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Details'),
      ),
      body: BlocBuilder<CategorizedBloc, CategorizedState>(
        builder: (context, state) {
          if (state is CategorizedLoading || state is CategorizedInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategorizedLoaded) {
            final summary =
                state.categorizedSummaries[categoryName.toLowerCase()];

            if (summary == null) {
              return const Center(
                  child: Text('No data found for this category.'));
            }

            // Fetch filtered transactions
            // Using a FutureBuilder to handle asynchronous data fetching
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Category: ${summary.category}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total Income: ${summary.totalIncome.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  Text(
                    'Total Expense: ${summary.totalExpense.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  Text(
                    'Net Total: ${(summary.totalIncome - summary.totalExpense).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: (summary.totalIncome - summary.totalExpense) >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Transactions:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: FutureBuilder<List<TransactionAllModel>>(
                      future: context
                          .read<CategorizedBloc>()
                          .repository
                          .fetchFilteredTransactions(
                            categoryName: categoryName,
                            startDate: null, // Adjust if you have date range
                            endDate: null,
                          ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final transactions = snapshot.data!;
                          if (transactions.isEmpty) {
                            return const Center(
                                child: Text('No transactions available.'));
                          }
                          return ListView.builder(
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              final tx = transactions[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                color: tx.categoryColor.withOpacity(0.1),
                                child: ListTile(
                                  leading: Icon(
                                    tx.type.toLowerCase() == 'income'
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: tx.type.toLowerCase() == 'income'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  title: Text(tx.memo.isNotEmpty
                                      ? tx.memo
                                      : 'Transaction ID: ${tx.id}'),
                                  subtitle: Text('${tx.createdAt.toLocal()}'),
                                  trailing: Text(
                                    tx.amount.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: tx.type.toLowerCase() == 'income'
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text('No transactions available.'));
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is CategorizedError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            logger.w('Unhandled State in CategorizedSummaryScreen: $state');
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}
