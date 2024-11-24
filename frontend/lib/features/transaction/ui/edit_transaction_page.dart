import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/navBar/main_layout.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<TransactionAddBloc>().add(FetchBanksAndCategories());
  }

  void _onExpenseSubmit(CreateExpenseData data) {
    final request = CreateTransactionRequest(
      bankId: data.bank.id,
      type: 'expense',
      amount: data.amount,
      categoryId: data.category.id,
      createdAtDate: data.date.toIso8601String().split('T').first,
      createdAtTime: data.time != null
          ? "${data.time!.hour}:${data.time!.minute}:00"
          : null,
      memo: data.note,
    );

    // Update the transaction
    context.read<TransactionAddBloc>().add(AddTransactionEvent(request));

    // Remove the old transaction from local storage
    widget.onTransactionRemoved();

    // Navigate back to the notification page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NotificationPage()),
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
        title: const Text('Edit Transaction'),
      ),
      body: BlocBuilder<TransactionAddBloc, TransactionState>(
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
                    (category) => category.id == widget.notification.categoryId,
                    orElse: () => Category(id: -1, name: 'Uncategorized'),
                  );

            final initialData = CreateExpenseData(
              bank: initialBank,
              category:
                  initialCategory ?? Category(id: -1, name: 'Uncategorized'),
              amount: widget.notification.amount,
              note: widget.notification.memo,
              date: DateFormat('dd/MM/yy').parse(widget.notification.date),
            );

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ExpenseForm(
                banks: _banks,
                categories: _categories,
                onSubmit: _onExpenseSubmit,
                initialData: initialData,
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
    );
  }
}
