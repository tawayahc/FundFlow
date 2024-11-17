import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/notification/transaction_card.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_bloc.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_event.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/features/home/pages/category/edit_category_page.dart';

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
        builder: (context, transactionState) {
          if (transactionState is TransactionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (transactionState is TransactionsLoaded) {
            final sortedTransactions = List.from(transactionState.transactions)
              ..sort((a, b) => DateTime.parse(b.createdAt)
                  .compareTo(DateTime.parse(a.createdAt)));

            return BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, categoryState) {
                return ListView.builder(
                  itemCount: sortedTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = sortedTransactions[index];
                    final isExpense = transaction.type == 'expense';

                    // Retrieve the matching Category object based on the transaction categoryId
                    Category category = Category(
                      id: 0,
                      name: 'undefined',
                      amount: 0.0,
                      color: Colors.grey,
                    );

                    if (transaction.categoryId != 0 &&
                        categoryState is CategoriesLoaded) {
                      category = categoryState.categories.firstWhere(
                        (cat) => cat.id == transaction.categoryId,
                        orElse: () => category,
                      );
                    }

                    final categoryName = category.name;
                    final isClickable =
                        isExpense && categoryName == 'undefined';

                    return GestureDetector(
                      onTap: () {
                        if (isClickable) {
                          // Change this to edit transaction page

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => EditCategoryPage(
                          //       category: category,
                          //     ),
                          //   ),
                          // );
                        }
                      },
                      child: TransactionCard(transaction: transaction),
                    );
                  },
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
    );
  }
}
