import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/manageBankAccount/ui/transaction_item.dart';
import 'package:fundflow/features/home/models/category.dart' as categories;

import '../../../core/themes/app_styles.dart';
import '../../home/models/transaction.dart';
import '../../home/pages/edit_category_page.dart';
import '../../home/repository/transaction_repository.dart';

class CategoryPage extends StatefulWidget {
  final categories.Category category;
  const CategoryPage({super.key, required this.category});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with SingleTickerProviderStateMixin {
  String _type = 'income';
  late TabController _tabController;

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
      return transactions.where((transaction) => transaction.amount > 0).toList();
    } else {
      // Show only outcome transactions
      return transactions.where((transaction) => transaction.amount < 0).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
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
                    builder: (context) => EditCategoryPage(category: widget.category),
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
              Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 4, 0), // padding (left, top, right, bottom)
                width: double.infinity, // สุดขอบ
                decoration: BoxDecoration(
                  //---------- **สี category
                  color: widget.category.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        SizedBox(width: 16),
                        Text(
                          'ยอดเงินคงเหลือ',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 0),
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                      height: 3,
                      indent: 2,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        '฿ ${widget.category.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'ประวัติการทำรายการ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          color: AppColors.primary,
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          indicator: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white,
                          tabs: const [
                            Tab(
                              icon: Icon(Icons.download) ,
                            ),
                            Tab(
                              icon: Icon(Icons.upload),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                            category: filteredItem.category,
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
        )
      ),
    );
  }
}

