import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/home/category_balance_box.dart';
import 'package:fundflow/features/manageBankAccount/ui/transaction_item.dart';
import 'package:fundflow/features/home/models/category.dart' as categories;

import '../../../core/themes/app_styles.dart';
import '../../home/models/transaction.dart';
import '../../home/pages/category/edit_category_page.dart';
import '../../home/repository/transaction_repository.dart';


class CategoryPage extends StatefulWidget {
  final categories.Category category;
  const CategoryPage({super.key, required this.category});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  String _type = 'income';
  late TabController _tabController;
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = ['income', 'expense'].indexOf(_type);

    _tabController.addListener(() {
      setState(() {
        _type = ['income', 'expense'][_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Transaction> get filteredTransactions {
    if (_tabController.index == 0) {
      // Show only income transactions
      return transactions
          .where((transaction) => transaction.amount > 0)
          .toList();
    } else {
      // Show only outcome transactions
      return transactions
          .where((transaction) => transaction.amount < 0)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
          appBar: AppBar(
             leading: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: Color(0xFF414141),
                iconSize: 20,
                onPressed: () {
                  Navigator.pop(context); 
                },
              ),
            ],
          ),
          centerTitle: true,
          title: const Text(
            'หมวดหมู่',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF414141),
            ),
          ),         
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
                // ----------- ชื่อ category
                    Text(
                  widget.category.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                        ),
                    ),
                //---------- **กล่องเงิน
                CategoryBalanceBox(color: widget.category.color, category: widget.category, date: '00:00 น.'),

                const SizedBox(height: 30),
                const Text(
                  'ประวัติการทำรายการ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                
                // Transaction ตรงนี้
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final filteredItem = filteredTransactions[index];
                            return TransactionItem(
                              amount: filteredItem.amount,
                              category: 'filteredItem.category',
                              type: filteredItem.memo,
                            );
                          },
                          childCount: filteredTransactions.length,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
