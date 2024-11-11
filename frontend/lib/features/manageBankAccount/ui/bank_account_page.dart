import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/pages/edit_bank_page.dart';
import 'package:fundflow/features/home/ui/bank_section.dart';
import 'package:fundflow/features/manageBankAccount/ui/transaction_item.dart';

import '../../../core/themes/app_styles.dart';
import '../../home/models/bank.dart';
import '../../home/models/transaction.dart';
import '../../home/repository/transaction_repository.dart';

class BankAccountPage extends StatefulWidget {
  final Bank bank;
  final Map<String, Color> bankColorMap;
  const BankAccountPage(
      {super.key, required this.bank, required this.bankColorMap});

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
    Color color = bankColorMap[widget.bank.bank_name] ?? Colors.white;
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                // Navigate to the EditBankPage and get the updated bank
                final updatedBank = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditBankPage(bank: widget.bank),
                  ),
                );

                if (updatedBank != null) {
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
              //---------- **รูปธนาคาร
              Row(
                children: [
                  // รูปธนาคาร
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: color,
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
                        widget.bank.bank_name,
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
                  color: color,
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
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                      height: 3,
                      indent: 2,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        '฿ ${widget.bank.amount}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Align(
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
