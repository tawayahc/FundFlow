import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/category_balance_box.dart';
import 'package:fundflow/features/home/models/category.dart' as categories;

import '../../../core/widgets/navBar/main_layout.dart';
import '../../../core/widgets/notification/transaction_card.dart';
import '../../home/bloc/transaction/transaction_bloc.dart';
import '../../home/bloc/transaction/transaction_state.dart';
import '../../home/models/transaction.dart';
import '../../home/pages/category/edit_category_page.dart';

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // ความสูงของ AppBar
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 25.0), // เพิ่ม GlobalPadding เฉพาะ AppBar
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 20, // ปรับขนาดไอคอน
              color: Color(0xFF414141),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavBar(),
                  ),
                );
              },
            ),
            title: const Text(
              "หมวดหมู่",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF414141)),
            ),
            centerTitle: true,
            elevation: 0, // ลบเงาของ AppBar
            backgroundColor: Colors.white, // พื้นหลังสีขาว
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
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit_outlined,
                        color: Color(0xFFFF5C5C),
                        size: 16, // ปรับขนาดไอคอนให้เล็กลง
                      ),
                      SizedBox(width: 4), // ปรับระยะห่างระหว่างไอคอนและข้อความ
                      Text(
                        "แก้ไข",
                        style: TextStyle(
                          fontSize: 12,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: const Text(
              'ประวัติการทำรายการ',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF414141)),
            ),
          ),
          const SizedBox(height: 12),
          // Container for "รายจ่าย" section
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
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: const Text(
                      'รายจ่าย',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF414141)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (context, transactionState) {
                        if (transactionState is TransactionsLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (transactionState is TransactionsLoaded) {
                          final categoryTransactions = transactionState
                              .transactions
                              .where((transaction) =>
                                  transaction.categoryId == widget.category.id)
                              .toList();

                          final sortedTransactions =
                              List.from(categoryTransactions)
                                ..sort((a, b) => DateTime.parse(b.createdAt)
                                    .compareTo(DateTime.parse(a.createdAt)));

                          return ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            itemCount: sortedTransactions.length,
                            itemBuilder: (context, index) {
                              final transaction = sortedTransactions[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: TransactionCard(
                                  transaction: transaction,
                                ),
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
        ],
      ),
    );
  }
}
