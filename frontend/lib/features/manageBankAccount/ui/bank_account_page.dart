import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/bank_balance_box.dart';
import 'package:fundflow/core/widgets/management/delete_transaction_page.dart';
import 'package:fundflow/core/widgets/management/transaction_card.dart';
import 'package:fundflow/core/widgets/management/transfer_transaction_card.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
import 'package:fundflow/features/home/bloc/bank/bank_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_event.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_bloc.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_event.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_state.dart';
import 'package:fundflow/features/home/models/transaction.dart';
import 'package:fundflow/features/home/pages/bank/edit_bank_page.dart';
import '../../home/models/bank.dart';

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
  const BankAccountPage({Key? key, required this.bank}) : super(key: key);

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
        if (_type == 'transfer') {
          context.read<BankBloc>().add(LoadTransfers());
        }
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
          color: const Color(0xFF414141),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
          ),
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
                                    fontSize: 12,
                                    color: Color(0xFFFF5C5C),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 45.0),
            child: Text(
              'ประวัติการทำรายการ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF414141),
              ),
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
                children: [
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: const Color(0xFF41486D),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF41486D),
                      tabs: const [
                        Tab(text: 'รายรับ'),
                        Tab(text: 'รายจ่าย'),
                        Tab(text: 'ย้ายเงิน'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _type == 'transfer'
                        ? BlocBuilder<BankBloc, BankState>(
                            builder: (context, bankState) {
                              if (bankState is TransfersLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (bankState is TransfersLoaded) {
                                final transfers = bankState.transfers
                                    .where((transfer) =>
                                        transfer.fromBankId == widget.bank.id ||
                                        transfer.toBankId == widget.bank.id)
                                    .toList();

                                if (transfers.isEmpty) {
                                  return const Center(
                                      child: Text('ไม่มีรายการโอนเงิน'));
                                }

                                return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  itemCount: transfers.length,
                                  itemBuilder: (context, index) {
                                    final transfer = transfers[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: TransferTransactionCard(
                                        transfer: transfer,
                                        currentBankId: widget.bank.id,
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Center(
                                    child: Text('ไม่สามารถโหลดรายการโอนได้'));
                              }
                            },
                          )
                        : BlocBuilder<TransactionBloc, TransactionState>(
                            builder: (context, transactionState) {
                              if (transactionState is TransactionsLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (transactionState
                                  is TransactionsLoaded) {
                                final transactions = transactionState
                                    .transactions
                                    .where((t) =>
                                        t.bankId == widget.bank.id &&
                                        t.type == _type)
                                    .toList();

                                if (transactions.isEmpty) {
                                  return const Center(
                                      child: Text('ไม่มีรายการ'));
                                }

                                final sortedTransactions = List.from(
                                    transactions)
                                  ..sort((a, b) => DateTime.parse(b.createdAt)
                                      .compareTo(DateTime.parse(a.createdAt)));

                                return ListView.builder(
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
                                        child: TransactionCard(
                                            transaction: transaction),
                                      ),
                                    );
                                  },
                                );
                              } else if (transactionState
                                  is TransactionsLoadError) {
                                return Center(
                                    child: Text(transactionState.message));
                              } else {
                                return const Center(
                                    child: Text('เกิดข้อผิดพลาด'));
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
}

Map<String, Color> bankColorMap = {
  'ธนาคารกสิกรไทย': Colors.green,
  'ธนาคารกรุงไทย': Colors.blue,
  'ธนาคารไทยพาณิชย์': Colors.purple,
  'ธนาคารกรุงเทพ': const Color.fromARGB(255, 10, 35, 145),
  'ธนาคารกรุงศรีอยุธยา': const Color(0xFFffe000),
  'ธนาคารออมสิน': Colors.pink,
  'ธนาคารธนชาต': const Color(0xFFF68B1F),
  'ธนาคารเกียรตินาคิน': const Color(0xFF004B87),
  'ธนาคารซิตี้แบงก์': const Color(0xFF1E90FF),
  'ธนาคารเมกะ': const Color(0xFF3B5998),
};
