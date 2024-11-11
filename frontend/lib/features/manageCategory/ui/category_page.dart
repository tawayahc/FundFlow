import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/manageBankAccount/ui/transaction_item.dart';

import '../../../core/themes/app_styles.dart';
import '../../home/models/transaction.dart';
import '../../home/repository/transaction_repository.dart';

class CategoryPage extends StatefulWidget {
  final Category category;
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushNamed(context, '/home'); // ย้อนกลับไปยังหน้าก่อนหน้า
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //---------- **ชื่อ category
              Row(
                children: [
                  const Spacer(),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'หิว',
                      style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.grey[500]),
                      onPressed: () {
                        Navigator.pushNamed(context, '/change_category_name');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              //---------- **กล่องเงิน
              Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 4, 0), // padding (left, top, right, bottom)
                width: double.infinity, // สุดขอบ
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 16),
                        Text(
                          'ยอดเงินคงเหลือ',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 0),
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                      height: 3,
                      indent: 2,
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        '฿ 1000000.00',
                        style: TextStyle(
                            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'ข้อมูล ณ เวลา 00:00 น.',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                        textAlign: TextAlign.right,
                      ),
                    )
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
