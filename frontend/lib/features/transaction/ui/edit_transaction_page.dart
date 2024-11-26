import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/pages/notification/notification.dart';
import 'package:fundflow/features/transaction/bloc/transaction_state.dart';
import 'package:fundflow/features/transaction/model/create_transaction_request_model.dart';
import 'package:fundflow/features/transaction/ui/expense_form.dart';
import 'package:fundflow/features/transaction/model/bank_model.dart';
import 'package:fundflow/features/transaction/model/category_model.dart';
import 'package:fundflow/features/transaction/model/form_model.dart';
import 'package:fundflow/features/transaction/bloc/transaction_bloc.dart';
import 'package:fundflow/features/transaction/bloc/transaction_event.dart';
import 'package:fundflow/features/home/models/notification.dart' as model;
import 'package:intl/intl.dart';

class EditTransactionPage extends StatefulWidget {
  final model.Notification notification;
  final VoidCallback onTransactionRemoved;

  const EditTransactionPage({
    Key? key,
    required this.notification,
    required this.onTransactionRemoved,
  }) : super(key: key);

  @override
  _EditTransactionPageState createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  List<Bank> _banks = [];
  List<Category> _categories = [];
  int _selectedIndex = 1; // Default selected button index
  final List<String> _transactionTypes = ['รายรับ', 'รายจ่าย', 'ย้ายเงิน'];

  @override
  void initState() {
    super.initState();
    context.read<TransactionAddBloc>().add(FetchBanksAndCategories());
  }

  void _onExpenseSubmit(CreateExpenseData data) {
    final transactionType = _transactionTypes[_selectedIndex];
    final request = CreateTransactionRequest(
      bankId: data.bank.id,
      type: transactionType == 'รายรับ'
          ? 'income'
          : transactionType == 'รายจ่าย'
              ? 'expense'
              : 'transfer',
      amount: data.amount,
      categoryId: data.category.id,
      createdAtDate: data.date.toIso8601String().split('T').first,
      createdAtTime: data.time != null
          ? "${data.time!.hour}:${data.time!.minute}:00"
          : null,
      memo: data.note,
    );

    // Show confirmation modal
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: const [
            Icon(
              Icons.warning_rounded,
              color: Colors.red,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              'คุณต้องการที่จะลบ\nรายการนี้หรือไม่',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            onPressed: () {
              // Remove the old transaction
              widget.onTransactionRemoved();

              // Update the transaction
              context
                  .read<TransactionAddBloc>()
                  .add(AddTransactionEvent(request));

              // Close the modal and navigate back
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationPage()),
              );
            },
            child: const Text(
              'ลบรายการ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'ยกเลิก',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'แก้ไขธุรกรรม',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF414141),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Toggle buttons for transaction types
          Center(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  _transactionTypes.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index; // Update selected transaction type
                      });
                    },
                    child: Container(
                      height: 43, // Button height
                      width: 85, // Button width
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _selectedIndex == index
                            ? const Color(0xFF41486D) // Selected button color
                            : Colors.white, // Unselected button color
                        boxShadow: _selectedIndex == index
                            ? [
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
                              ]
                            : [],
                      ),
                      child: Text(
                        _transactionTypes[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _selectedIndex == index
                              ? Colors.white // Selected text color
                              : const Color(0xFF41486D), // Unselected text color
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Transaction form content
          Expanded(
            child: BlocBuilder<TransactionAddBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BanksAndCategoriesLoaded) {
                  _banks = state.banks;
                  _categories = state.categories;

                  final initialBank = _banks.firstWhere(
                    (bank) => bank.name == widget.notification.bankName,
                    orElse: () => Bank(id: 0, name: 'Unknown'),
                  );

                  final initialCategory = widget.notification.categoryId == -1
                      ? null
                      : _categories.firstWhere(
                          (category) =>
                              category.id == widget.notification.categoryId,
                          orElse: () =>
                              Category(id: -1, name: 'Uncategorized'),
                        );

                  final initialData = CreateExpenseData(
                    bank: initialBank,
                    category: initialCategory ??
                        Category(id: -1, name: 'Uncategorized'),
                    amount: widget.notification.amount,
                    note: widget.notification.memo,
                    date: DateFormat('dd/MM/yy')
                        .parse(widget.notification.date),
                  );

                  return GlobalPadding(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ExpenseForm(
                        banks: _banks,
                        categories: _categories,
                        onSubmit: _onExpenseSubmit,
                        initialData: initialData,
                      ),
                    ),
                  );
                } else if (state is TransactionFailure) {
                  return Center(
                    child: Text('Error loading data: ${state.error}'),
                  );
                } else {
                  return const Center(child: Text('Loading...'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
