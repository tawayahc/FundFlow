import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/home/category_balance_box.dart';
import 'package:fundflow/features/home/models/category.dart' as categories;

import '../../../core/themes/app_styles.dart';
import '../../../core/widgets/navBar/main_layout.dart';
import '../../../core/widgets/notification/transaction_card.dart';
import '../../home/bloc/category/category_bloc.dart';
import '../../home/bloc/category/category_state.dart';
import '../../home/bloc/transaction/transaction_bloc.dart';
import '../../home/bloc/transaction/transaction_state.dart';
import '../../home/models/transaction.dart';
import '../../home/pages/category/edit_category_page.dart';
import '../../home/repository/transaction_repository.dart';

class CategoryPage extends StatefulWidget {
  final categories.Category category;
  const CategoryPage({super.key, required this.category});

  @override
  State<StatefulWidget> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
          appBar: AppBar(
            leading: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  iconSize: 20,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                        builder: (context) =>
                    const BottomNavBar())); // กลับไปหน้าก่อนหน้า (SettingsPage)
                  },
                ),
              ],
            ),
            // ----------- ชื่อ category
            title: Text(widget.category.name),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  // Navigate to the EditCategoryPage and get the updated category
                  final updatedCategory = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditCategoryPage(category: widget.category),
                    ),
                  );

                  // If there's an updated category, do something with it (e.g., update the list)
                  if (updatedCategory != null) {
                    // Handle updated category (e.g., update the state, show a message, etc.)
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
                const SizedBox(height: 16),
                //---------- **กล่องเงิน
                CategoryBalanceBox(color: widget.category.color, category: widget.category, date: '00:00 น.'),

                const SizedBox(height: 30),
                const Text(
                  'ประวัติการทำรายการ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Transaction ตรงนี้
                Expanded(
                  child: BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, transactionState) {
                      if (transactionState is TransactionsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (transactionState is TransactionsLoaded) {
                        final categoryTransactions = transactionState.transactions
                            .where((transaction) => transaction.categoryId == widget.category.id)
                            .toList();

                        final sortedTransactions = List.from(categoryTransactions)
                          ..sort((a, b) => DateTime.parse(b.createdAt)
                              .compareTo(DateTime.parse(a.createdAt)));


                        return BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, categoryState) {
                            return ListView.builder(
                              itemCount: sortedTransactions.length,
                              itemBuilder: (context, index) {
                                final transaction = sortedTransactions[index];
                                final isExpense = transaction.type == 'expense';

                                return GestureDetector(
                                  onTap: () {

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
                ),
              ],
            ),
          )),
    );
  }
}
