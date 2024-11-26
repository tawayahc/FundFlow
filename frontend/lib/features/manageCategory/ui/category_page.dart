import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/home/category_balance_box.dart';
import 'package:fundflow/core/widgets/management/transaction_card_for_category.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/home/models/category.dart' as categories;

import '../../../core/themes/app_styles.dart';
import '../../home/bloc/category/category_bloc.dart';
import '../../home/bloc/category/category_state.dart';
import '../../home/bloc/transaction/transaction_bloc.dart';
import '../../home/bloc/transaction/transaction_state.dart';
import '../../home/models/transaction.dart';
import '../../home/pages/category/edit_category_page.dart';
import '../../../core/widgets/management/delete_transaction_page.dart';

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
          title: Text(widget.category.name),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final updatedCategory = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditCategoryPage(category: widget.category),
                  ),
                );

                if (updatedCategory != null) {
                  // Handle updated category if needed
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
              // กล่องเงิน
              CategoryBalanceBox(
                color: widget.category.color,
                category: widget.category,
                date: '00:00 น.',
              ),
              const SizedBox(height: 30),
              const Text(
                'ประวัติการทำรายการ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // รายการ Transaction
              Expanded(
                child: BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, transactionState) {
                    if (transactionState is TransactionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (transactionState is TransactionsLoaded) {
                      final categoryTransactions = transactionState.transactions
                          .where((transaction) =>
                              transaction.categoryId == widget.category.id)
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

                              return GestureDetector(
                                onTap: () {
                                  _showDeleteTransactionModal(
                                      context, transaction);
                                },
                                child: TransactionCardForCategory(
                                    transaction: transaction),
                              );
                            },
                          );
                        },
                      );
                    } else if (transactionState is TransactionsLoadError) {
                      return Center(
                          child: Text(transactionState.message ?? 'Error'));
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
      barrierDismissible: false, // ปิด Modal โดยการกดด้านนอกไม่ได้
      barrierColor: Colors.black54, // พื้นหลังโปร่งแสงสีดำ
      builder: (BuildContext context) {
        return DeleteTransactionPage(transaction: transaction);
      },
    );
  }
}
