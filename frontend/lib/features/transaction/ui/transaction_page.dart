// ui/transaction_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/image_upload/ui/image_upload_page.dart';
import 'package:fundflow/features/transaction/model/bank_model.dart';
import 'package:fundflow/features/transaction/model/category_model.dart';
import 'package:fundflow/features/transaction/model/create_transfer_request.dart';
import 'package:fundflow/features/transaction/widgets/tab_item.dart';
import 'package:intl/intl.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../model/form_model.dart';
import '../model/create_transaction_request_model.dart';
import 'expense_form.dart';
import 'income_form.dart';
import 'transfer_form.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with SingleTickerProviderStateMixin {
  String _type = 'income'; // Default type set to 'income'
  late TabController _tabController;

  // Data lists
  List<Bank> _banks = [];
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = ['income', 'expense', 'transfer'].indexOf(_type);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _type = ['income', 'expense', 'transfer'][_tabController.index];
        });
      }
    });

    // Fetch banks and categories when the page initializes
    context.read<TransactionAddBloc>().add(FetchBanksAndCategories());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formattedTime = DateFormat('HH:mm:ss').format(dt);
    return formattedTime;
  }

  void _onIncomeSubmit(CreateIncomeData data) {
    final request = CreateTransactionRequest(
      bankId: data.bank.id,
      type: 'income',
      amount: data.amount,
      categoryId: null,
      createdAtDate: data.date.toIso8601String().split('T').first,
      createdAtTime: data.time != null ? formatTimeOfDay(data.time!) : null,
      memo: data.note,
    );
    context.read<TransactionAddBloc>().add(AddTransactionEvent(request));
  }

  void _onExpenseSubmit(CreateExpenseData data) {
    final request = CreateTransactionRequest(
      bankId: data.bank.id,
      type: 'expense',
      amount: data.amount,
      categoryId: data.category.id,
      createdAtDate: data.date.toIso8601String().split('T').first,
      createdAtTime: data.time != null ? formatTimeOfDay(data.time!) : null,
      memo: data.note,
    );
    context.read<TransactionAddBloc>().add(AddTransactionEvent(request));
  }

  void _onTransferSubmit(CreateTransferData data) {
    final request = CreateTransferRequest(
      fromBankId: data.fromBank.id,
      toBankId: data.toBank.id,
      amount: data.amount,
      createdAtDate: data.date.toIso8601String().split('T').first,
      createdAtTime: data.time != null ? formatTimeOfDay(data.time!) : null,
    );
    context.read<TransactionAddBloc>().add(AddTransferEvent(request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'เพิ่มรายการ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocListener<TransactionAddBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction added successfully')),
              );
            } else if (state is TransactionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          child: BlocBuilder<TransactionAddBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BanksAndCategoriesLoaded) {
                _banks = state.banks;
                _categories = state.categories;
              } else if (state is TransactionFailure) {
                return Center(
                  child: Text('Error loading data: ${state.error}'),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Tabs for Transaction Type

                    Container(
                      width: 259,
                      height: 43,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 0),
                              blurRadius: 3.6,
                              spreadRadius: 1,
                            )
                          ]),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        labelColor: AppColors.white,
                        unselectedLabelColor: AppColors.primary,
                        tabs: const [
                          TabItem(
                            title: "รายรับ",
                          ),
                          TabItem(
                            title: "รายจ่าย",
                          ),
                          TabItem(
                            title: "ย้ายเงิน",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageUploadPage()));
                            },
                            child: Text('image')),
                        //FIX: Remove the gallery button
                        // ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => GalleryPage()));
                        //     },
                        //     child: Text('gallery')),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.medium),
                    // Form Section
                    if (_type == 'income') ...[
                      IncomeForm(
                        key: ValueKey(_banks), // Use ValueKey with banks list
                        banks: _banks,
                        onSubmit: _onIncomeSubmit,
                      ),
                    ] else if (_type == 'expense') ...[
                      ExpenseForm(
                        key: ValueKey(_banks.toString() +
                            _categories.toString()), // Unique Key
                        banks: _banks,
                        categories: _categories,
                        onSubmit: _onExpenseSubmit,
                      ),
                    ] else if (_type == 'transfer') ...[
                      TransferForm(
                        key: ValueKey(_banks),
                        banks: _banks,
                        onSubmit: _onTransferSubmit,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ));
  }
}
