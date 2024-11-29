import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_button.dart';
import 'package:fundflow/core/widgets/custom_dropdown.dart';
import 'package:fundflow/core/widgets/custom_input_inkwell.dart';
import 'package:fundflow/core/widgets/custom_input_transaction_box.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_event.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import '../../../transaction/model/transaction.dart';
import '../../bloc/notification/notification_bloc.dart';
import '../../bloc/notification/notification_event.dart';
import '../../../transaction/repository/transaction_repository.dart'; // For fetching banks

class EditTransactionPage extends StatefulWidget {
  final TransactionResponse transaction;

  EditTransactionPage({Key? key, required this.transaction}) : super(key: key);

  @override
  _EditTransactionPageState createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  late TransactionResponse transaction;
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  late TransactionAddRepository _transactionRepository; // For fetching banks

  @override
  void initState() {
    super.initState();
    transaction = widget.transaction;

    _selectedDate = transaction.date != null && transaction.date!.isNotEmpty
        ? DateTime.parse(transaction.date!)
        : DateTime.now();

    _amountController.text = transaction.amount.toString();
    _noteController.text = transaction.memo ?? '';

    _transactionRepository =
        RepositoryProvider.of<TransactionAddRepository>(context);

    if (transaction.possibleBanks == null ||
        transaction.possibleBanks!.isEmpty) {
      _fetchPossibleBanks();
    }

    if (transaction.possibleCategories == null ||
        transaction.possibleCategories!.isEmpty) {
      context.read<CategoryBloc>().add(LoadCategories());
    }
    logger.d(
        'Marking notification as read for metadata: ${transaction.metadata}');
    // Dispatch MarkNotificationAsRead event here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markAsRead();
    });
  }

  void _markAsRead() {
    logger.i(
        'Marking notification as read for metadata: ${transaction.metadata}');
    // Dispatch MarkNotificationAsRead event
    context.read<NotificationBloc>().add(
          MarkNotificationAsRead(transaction: transaction),
        );
  }

  Future<void> _fetchPossibleBanks() async {
    try {
      final userBanks = await _transactionRepository.fetchBanks();

      final matchingBanks = userBanks
          .where((bank) =>
              bank.bankName.toLowerCase() == transaction.bank.toLowerCase())
          .toList();

      setState(() {
        transaction.possibleBanks = matchingBanks;
      });
    } catch (e) {
      // Handle error, possibly by showing a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch banks: $e')),
      );
    }
  }

  void _deleteNotification() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบการแจ้งเตือนนี้?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close the dialog
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              // Dispatch DismissNotification event
              context.read<NotificationBloc>().add(
                    DismissNotification(transaction: transaction),
                  );
              Navigator.pop(context); // Close the EditTransactionPage
            },
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
  }

  void _selectDate() {
    BottomPicker.date(
      pickerTitle: const Text(
        'เลือกวันที่',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      titlePadding: const EdgeInsets.all(20),
      dismissable: true,
      initialDateTime: _selectedDate,
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(2100),
      onSubmit: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
      onClose: () {
        Navigator.of(context).pop();
      },
      buttonSingleColor: AppColors.primary,
    ).show(context);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalPadding(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('แก้ไขรายการ'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteNotification,
            ),
          ],
        ),
        body: transaction.possibleBanks == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Display Transaction Amount
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'จำนวนเงิน',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '฿ ${transaction.amount}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Bank Selection
                      if (transaction.possibleBanks != null &&
                          transaction.possibleBanks!.isNotEmpty)
                        CustomDropdown<int>(
                          prefixIcon: Icons.account_balance,
                          hintText: 'เลือกธนาคาร',
                          selectedItem: transaction.bankId,
                          items: transaction.possibleBanks!
                              .map((bank) => bank.id)
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              transaction.bankId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'กรุณาเลือกธนาคาร';
                            }
                            return null;
                          },
                          displayItem: (int bankId) {
                            final bank = transaction.possibleBanks!
                                .firstWhere((b) => b.id == bankId);
                            return "${bank.bankName} (${bank.name})";
                          },
                        ),
                      const SizedBox(height: 16),
                      CustomInputInkwell(
                          prefixIcon: Icons.calendar_today,
                          labelText: transaction.date ?? 'เลือกวันที่',
                          onTap: _selectDate),
                      const SizedBox(height: 16),
                      // Category Selection
                      BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, state) {
                          if (state is CategoriesLoaded) {
                            return CustomDropdown<int>(
                              prefixIcon: Icons.category,
                              hintText: 'เลือกหมวดหมู่',
                              selectedItem: transaction.categoryId != -1
                                  ? transaction.categoryId
                                  : null,
                              items: state.categories
                                  .map((category) => category.id)
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  transaction.categoryId = value!;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'กรุณาเลือกหมวดหมู่';
                                }
                                return null;
                              },
                              displayItem: (int categoryId) {
                                final category = state.categories
                                    .firstWhere((c) => c.id == categoryId);
                                return category
                                    .name; // Display the category name
                              },
                            );
                          } else if (state is CategoriesLoading) {
                            return const CircularProgressIndicator();
                          } else {
                            return const Text('Failed to load categories');
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // Memo
                      CustomInputTransactionBox(
                        labelText: 'Memo',
                        prefixIcon: const Icon(
                          Icons.edit,
                          color: Color(0xFFD0D0D0),
                        ),
                        controller:
                            TextEditingController(text: transaction.memo),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอก Memo';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Buttons Row
                      CustomButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _markAsRead();
                            // Remove the notification and add the transaction
                            context.read<NotificationBloc>().add(
                                  RemoveNotification(transaction: transaction),
                                );
                            Navigator.pop(context, transaction);
                          }
                        },
                        text: 'บันทึก',
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
