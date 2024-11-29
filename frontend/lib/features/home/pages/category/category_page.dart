import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/home/category_balance_box.dart';
import 'package:fundflow/core/widgets/management/transaction_card_for_category.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_event.dart';
import 'package:fundflow/features/home/models/category.dart' as categories;
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../models/transaction.dart';
import 'edit_category_page.dart';
import '../../../../core/widgets/management/delete_transaction_page.dart';

class CategoryPage extends StatefulWidget {
  final categories.Category category;

  const CategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoryPageState();
}

void _showDeleteTransactionModal(
    BuildContext context, Transaction transaction) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54, // โปร่งแสง
    builder: (BuildContext context) {
      return DeleteTransactionPage(transaction: transaction);
    },
  );
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // Ensure that transactions are loaded
    context.read<TransactionBloc>().add(LoadTransactions());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // AppBar height
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 20,
              color: AppColors.darkGrey,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const BottomNavBar()),
                );
              },
            ),
            title: const Text(
              "หมวดหมู่",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Header with Category Name and Edit Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.category.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final updatedCategory = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditCategoryPage(category: widget.category),
                      ),
                    );

                    if (updatedCategory != null) {
                      // Handle updated category
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        color: Color(0xFFFF5C5C),
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "แก้ไข",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFFF5C5C),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Balance Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: CategoryBalanceBox(
              color: widget.category.color,
              category: widget.category,
              date: '00:00 น.',
            ),
          ),
          const SizedBox(height: 20),
          // Header for "ประวัติการทำรายการ"
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 45.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ประวัติการทำรายการ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Color(0xFFB2B2B2),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'แตะที่รายการเพื่อลบ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB2B2B2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          // Container for transaction list
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (context, transactionState) {
                        if (transactionState is TransactionsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (transactionState is TransactionsLoaded) {
                          final categoryTransactions = transactionState
                              .transactions
                              .where((transaction) =>
                                  transaction.categoryId ==
                                      widget.category.id &&
                                  transaction.type == 'expense')
                              .toList();

                          if (categoryTransactions.isEmpty) {
                            return const Center(
                              child: Text('ไม่มีรายการสำหรับหมวดหมู่นี้'),
                            );
                          }

                          final sortedTransactions =
                              List.from(categoryTransactions)
                                ..sort((a, b) => DateTime.parse(b.createdAt)
                                    .compareTo(DateTime.parse(a.createdAt)));

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              const Padding(
                                padding: EdgeInsets.only(left: 45.0),
                                child: Text(
                                  'รายจ่าย',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  itemCount: sortedTransactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction =
                                        sortedTransactions[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _showDeleteTransactionModal(
                                              context, transaction);
                                        },
                                        child: TransactionCardForCategory(
                                          transaction: transaction,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        } else if (transactionState is TransactionsLoadError) {
                          return Center(
                            child: Text(transactionState.message),
                          );
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
        ],
      ),
    );
  }
}
