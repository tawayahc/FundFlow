// ui/transaction_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_modal.dart';
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
  final Map<String, bool> _dialogShown = {
    'income': false,
    'expense': false,
    'transfer': false,
  };

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

        _handleTabLogic();
      }
    });

    context.read<TransactionAddBloc>().add(FetchBanksAndCategories());
  }

  void _handleTabLogic() {
    // Ensure modals are shown based on updated banks/categories

    if (_type == 'income' && _banks.isEmpty && !_dialogShown['income']!) {
      _showNotEnoughBanksDialog(
          'คุณยังไม่มีบัญชีธนาคาร\nกรุณากดเพิ่มธนาคาร', 'income');
    } else if (_type == 'expense' &&
        _banks.isEmpty &&
        !_dialogShown['expense']!) {
      _showNotEnoughBanksDialog(
          'คุณยังไม่มีบัญชีธนาคาร\nกรุณากดเพิ่มธนาคาร', 'expense');
    } else if (_type == 'expense' &&
        _categories.isEmpty &&
        !_dialogShown['expense']!) {
      _showNotEnoughBanksDialog(
          'คุณยังไม่มีบัญชีหมมวดหมู่\nกรุณากดเพิ่มหมวดหมู่', 'expense');
    } else if (_type == 'transfer' &&
        _banks.length < 2 &&
        !_dialogShown['transfer']!) {
      _showNotEnoughBanksDialog(
          'คุณมีบัญชีธนาคารไม่พอ\nกรุณากดเพิ่มธนาคาร', 'transfer');
    }
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

  void _showNotEnoughBanksDialog(String text, String type) {
    if (!_dialogShown[type]!) {
      _dialogShown[type] = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 22,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/home');
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 22,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 40,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          if (text ==
                              'คุณยังไม่มีบัญชีหมมวดหมู่\nกรุณากดเพิ่มหมวดหมู่') {
                            Navigator.pushNamed(context, '/addCategory');
                          } else {
                            Navigator.pushNamed(context, '/addBank');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor: AppColors.darkBlue,
                        ),
                        child: Text(
                          text == 'คุณยังไม่มีบัญชีหมมวดหมู่\nกรุณากดเพิ่มหมวดหมู่'
                              ? 'เพิ่มหมวดหมู่'
                              : 'เพิ่มธนาคาร',
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xffffffff)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ).then((_) {
          _dialogShown[type] = false; // Reset the flag when the dialog closes
        });
      });
    }
  }

  bool _isDialogShowing = false;

  void _showModal(BuildContext context, String text) {
    if (_isDialogShowing) {
      return;
    }

    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (BuildContext context) {
        return CustomModal(text: text);
      },
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
            } else if (state is TransactionFailure) {
              _showModal(context, 'เพิ่มรายการไม่สำเร็จ');
            } else if (state is BanksAndCategoriesLoaded) {
              setState(() {
                _banks = state.banks;
                _categories = state.categories;
              });

              // Call _handleTabLogic after data is loaded
              _handleTabLogic();
            }
          },
          child: BlocBuilder<TransactionAddBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoading) {
                return const Center(child: CircularProgressIndicator());
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
                    // Form Section
                    if (_type == 'income') ...[
                      IncomeForm(
                        key: ValueKey(_banks), // Use ValueKey with banks list
                        banks: _banks,
                        onSubmit: _onIncomeSubmit,
                      ),
                    ] else if (_type == 'expense') ...[
                      const SizedBox(height: AppSpacing.medium),
                      const Align(
                        alignment: Alignment.center,
                        child: const Text(
                          'เพิ่มรายการด้วยรูปภาพ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ImageUploadPage()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_file,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'เลือกรูปภาพ',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 199, 198, 198),
                      ),
                      ExpenseForm(
                        key: ValueKey(_banks.toString() +
                            _categories.toString()), // Unique Key
                        banks: _banks,
                        categories: _categories,
                        onSubmit: _onExpenseSubmit,
                      ),
                      const SizedBox(
                        height: 100,
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
