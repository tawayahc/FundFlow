import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/core/widgets/home/bank_balance_box.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/home/pages/bank/edit_bank_page.dart';
import 'package:fundflow/features/home/ui/bank_section.dart';

import '../../../core/themes/app_styles.dart';
import '../../../core/widgets/notification/transaction_card.dart';
import '../../home/bloc/category/category_bloc.dart';
import '../../home/bloc/category/category_state.dart';
import '../../home/bloc/transaction/transaction_bloc.dart';
import '../../home/bloc/transaction/transaction_event.dart';
import '../../home/bloc/transaction/transaction_state.dart';
import '../../home/models/bank.dart';
import '../../home/models/category.dart';
import '../../home/models/transaction.dart';
import '../../home/repository/transaction_repository.dart';

class BankAccountPage extends StatefulWidget {
  final Bank bank;
  const BankAccountPage({super.key, required this.bank});

  @override
  State<StatefulWidget> createState() => _BankAccountPageState();
}

class _BankAccountPageState extends State<BankAccountPage>
    with SingleTickerProviderStateMixin {
  String _type = 'income';
  List<Transaction> transactions = [];
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

  @override
  Widget build(BuildContext context) {
    context.read<TransactionBloc>().add(LoadTransactions());
    Color color = bankColorMap[widget.bank.bank_name] ?? Colors.grey;

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
                          builder: (context) => const BottomNavBar()));
                },
              ),
            ],
          ),
          centerTitle: true,
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
              BankBalanceBox(color: color, bank: widget.bank, date: '00:00 น.'),

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
                    child: Container(
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
                          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, transactionState) {
                    if (transactionState is TransactionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (transactionState is TransactionsLoaded) {
                      final bankTransactions = transactionState.transactions
                          .where((transaction) =>
                              transaction.bankId == widget.bank.id)
                          .toList();

                      final sortedTransactions = List.from(bankTransactions)
                        ..sort((a, b) => DateTime.parse(b.createdAt)
                            .compareTo(DateTime.parse(a.createdAt)));

                      final filteredTransactions = sortedTransactions
                          .where((transaction) => transaction.type == _type)
                          .toList();

                      return BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, categoryState) {
                          return ListView.builder(
                            itemCount: filteredTransactions.length,
                            itemBuilder: (context, index) {
                              final transaction = filteredTransactions[index];
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
                                child:
                                    TransactionCard(transaction: transaction),
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
        ),
      ),
    );
  }
}

Map<String, Color> bankColorMap = {
  'ธนาคารกสิกรไทย': Colors.green, // Kasikorn Bank
  'ธนาคารกรุงไทย': Colors.blue, // Krung Thai Bank
  'ธนาคารไทยพาณิชย์': Colors.purple, // Siam Commercial Bank
  'ธนาคารกรุงเทพ': const Color.fromARGB(255, 10, 35, 145), // Bangkok Bank
  'ธนาคารกรุงศรีอยุธยา': const Color(0xFFffe000), // Krungsri (Bank of Ayudhya)
  'ธนาคารออมสิน': Colors.pink, // Government Savings Bank
  'ธนาคารธนชาต': const Color(0xFFF68B1F), // Thanachart Bank
  'ธนาคารเกียรตินาคิน': const Color(0xFF004B87), // Kiatnakin Bank
  'ธนาคารซิตี้แบงก์': const Color(0xFF1E90FF), // Citibank
  'ธนาคารเมกะ': const Color(0xFF3B5998), // Mega Bank
};
