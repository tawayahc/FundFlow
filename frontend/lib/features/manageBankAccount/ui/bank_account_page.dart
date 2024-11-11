import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/manageBankAccount/ui/transaction_item.dart';

import '../../../core/themes/app_styles.dart';
import '../../home/models/bank.dart';
import '../../home/models/transaction.dart';
import '../../home/repository/transaction_repository.dart';

class BankAccountPage extends StatefulWidget {
  final Bank bank;
  const BankAccountPage({super.key, required this.bank});

  @override
  _BankAccountPageState createState() => _BankAccountPageState();
}

class _BankAccountPageState extends State<BankAccountPage>
    with SingleTickerProviderStateMixin {
  String _type = 'income';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = ['income', 'expense', 'transfer'].indexOf(_type);

    _tabController.addListener(() {
      setState(() {
        _type = ['income', 'expense', 'transfer'][_tabController.index];
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
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pushNamed(context,
                      '/pocket_management'); // ย้อนกลับไปยังหน้าก่อนหน้า
                },
              ),
              //---------- **รูปธนาคาร
              Row(
                children: [
                  // รูปธนาคาร
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF414141),
                    // backgroundImage: ,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ชื่อธนาคาร
                      Text(
                        widget.bank.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // ชื่อเต็ม
                      Text(
                        'ธนาคาร${widget.bank.name}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              //---------- **กล่องเงิน
              Container(
                padding: const EdgeInsets.fromLTRB(
                    0, 8, 4, 0), // padding (left, top, right, bottom)
                width: 296, // สุดขอบ
                decoration: BoxDecoration(
                  color: const Color(0xFF414141),
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
                        '฿ 10000',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
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
              // Transaction ตรงนี้
              Center(
                child: PreferredSize(
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                icon: Icon(Icons.download),
                              ),
                              Tab(
                                icon: Icon(Icons.upload),
                              ),
                              Tab(
                                icon: Icon(Icons.compare_arrows),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
        ),
      ),
    );
  }
}
