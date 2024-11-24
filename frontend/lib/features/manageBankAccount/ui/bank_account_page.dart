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

String _getBankLogo(String bankName) {
  final logos = {
    'ธนาคารกสิกรไทย': 'assets/LogoBank/Kplus.png',
    'ธนาคารกรุงไทย': 'assets/LogoBank/Krungthai.png',
    'ธนาคารไทยพาณิชย์': 'assets/LogoBank/SCB.png',
    'ธนาคารกรุงเทพ': 'assets/LogoBank/Krungthep.png',
    'ธนาคารกรุงศรีอยุธยา': 'assets/LogoBank/krungsri.png',
    'ธนาคารออมสิน': 'assets/LogoBank/GSB.png',
    'ธนาคารธนชาต': 'assets/LogoBank/ttb.png',
    'ธนาคารเกียรตินาคิน': 'assets/LogoBank/knk.png',
    'ธนาคารซิตี้แบงก์': 'assets/LogoBank/city.png',
    'ธนาคารเมกะ': 'assets/LogoBank/make.png',
  };

  final trimmedBankName = bankName.trim();

  String? matchedKey = logos.keys.firstWhere(
    (key) => key == trimmedBankName,
    orElse: () => '',
  );

  if (matchedKey.isEmpty) {
    debugPrint('No exact match for $trimmedBankName, using default image.');
    return 'assets/CashBox.png'; // Default fallback image
  }

  final path = logos[matchedKey];
  debugPrint('Matched bank name: $matchedKey, using path: $path');
  return path!;
}

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
            'บัญชีธนาคาร',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF414141),
            ),
          ),
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
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        _getBankLogo(widget.bank.bank_name),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint(
                              'Error loading image for ${widget.bank.bank_name}');
                          return Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
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
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: Color(0xFFFF5C5C),
                    onPressed: () async {
                      // Navigate to the EditBankPage and pass the bankColorMap
                      final updatedBank = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBankPage(
                            bank: widget.bank,
                            bankColorMap: widget
                                .bankColorMap, // Pass the required argument here
                          ),
                        ),
                      );

                      if (updatedBank != null) {
                        // Handle the updated bank (e.g., update the state, show a message, etc.)
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),
              //---------- **กล่องเงิน
              // Use BankBalanceBox Widget
              BankBalanceBox(
                title: 'ยอดเงินคงเหลือ',
                amount: widget.bank.amount,
                color: color,
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
                  child: Container(
                    height: 43,
                    width: 259,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      color: const Color(0xFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: const BoxDecoration(
                          color: Color(0xFF41486D),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: const Color(0xFF41486D),
                        tabs: const [
                          Tab(
                            child: Text(
                              'รายรับ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'รายจ่าย',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'ย้ายเงิน',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
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
