import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/bank_balance_box.dart';
import 'package:fundflow/core/widgets/notification/transaction_card.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_event.dart';
import 'package:fundflow/features/home/pages/bank/edit_bank_page.dart';

import '../../home/bloc/transaction/transaction_bloc.dart';
import '../../home/bloc/transaction/transaction_state.dart';
import '../../home/models/bank.dart';
import '../../home/models/transaction.dart';

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

  return logos[bankName.trim()] ?? 'assets/CashBox.png';
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 20,
          color: const Color(0xFF414141),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'บัญชีธนาคาร',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF414141),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Bank Logo
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
                        return const Icon(Icons.error, color: Colors.red);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bank Name
                      Text(
                        widget.bank.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Full Bank Name and Edit Button in the same row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.bank.bank_name,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final updatedBank = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditBankPage(
                                    bank: widget.bank,
                                    bankColorMap: bankColorMap,
                                  ),
                                ),
                              );

                              if (updatedBank != null) {
                                // Handle updated bank
                              }
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.edit_outlined,
                                  color: Color(0xFFFF5C5C),
                                  size: 16, // Adjusted icon size
                                ),
                                SizedBox(width: 4),
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
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Bank Balance Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: BankBalanceBox(
              title: 'ยอดเงินคงเหลือ',
              amount: widget.bank.amount,
              color: color,
            ),
          ),
          const SizedBox(height: 30),
          // Transaction History Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: const Text(
              'ประวัติการทำรายการ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF414141),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Transaction Section
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
                    padding: const EdgeInsets.symmetric(horizontal: 70.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
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
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'รายจ่าย',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'ย้ายเงิน',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                          // Filter transactions based on _type
                          final bankTransactions = transactionState.transactions
                              .where((transaction) =>
                                  transaction.bankId == widget.bank.id)
                              .toList();

                          final filteredTransactions = bankTransactions
                              .where((transaction) => transaction.type == _type)
                              .toList();

                          return ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            itemCount: filteredTransactions.length,
                            itemBuilder: (context, index) {
                              final transaction = filteredTransactions[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child:
                                    TransactionCard(transaction: transaction),
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

Map<String, Color> bankColorMap = {
  'ธนาคารกสิกรไทย': Colors.green, // Kasikorn Bank
  'ธนาคารกรุงไทย': Colors.blue, // Krung Thai Bank
  'ธนาคารไทยพาณิชย์': Colors.purple, // Siam Commercial Bank
  'ธนาคารกรุงเทพ': const Color.fromARGB(255, 10, 35, 145), // Bangkok Bank
  'ธนาคารกรุงศรี':
      const Color.fromARGB(255, 243, 201, 11), // Krungsri (Bank of Ayudhya)
  'ธนาคารออมสิน': Colors.pink, // Government Savings Bank
  'ธนาคารธนชาติ': const Color(0xFFF68B1F), // Thanachart Bank
  'ธนาคารเกียรตินาคิน': const Color(0xFF004B87), // Kiatnakin Bank
  'ธนาคารCity': const Color(0xFF1E90FF), // Citibank
  'ธนาคารMake': const Color.fromARGB(255, 104, 212, 50), // Make Bank
};
