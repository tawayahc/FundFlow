import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  late TransactionAddRepository _transactionRepository; // For fetching banks

  @override
  void initState() {
    super.initState();
    transaction = widget.transaction;

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
  }

  Future<void> _fetchPossibleBanks() async {
    final userBanks = await _transactionRepository.fetchBanks();

    final matchingBanks = userBanks
        .where((bank) =>
            bank.bankName.toLowerCase() == transaction.bank.toLowerCase())
        .toList();

    setState(() {
      transaction.possibleBanks = matchingBanks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transaction'),
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
                    Text(
                      'Amount: ฿${transaction.amount}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),

                    // Display Transaction Type
                    Text(
                      'Type: ${transaction.type}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),

                    // Bank Selection
                    if (transaction.possibleBanks != null &&
                        transaction.possibleBanks!.isNotEmpty)
                      DropdownButtonFormField<int>(
                        decoration:
                            const InputDecoration(labelText: 'Select Bank'),
                        items: transaction.possibleBanks!
                            .map(
                              (bank) => DropdownMenuItem<int>(
                                value: bank.id,
                                child: Text("${bank.bankName} (${bank.name})"),
                              ),
                            )
                            .toList(),
                        value: transaction.bankId,
                        onChanged: (value) {
                          setState(() {
                            transaction.bankId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a bank';
                          }
                          return null;
                        },
                      ),

                    // Date Picker
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Date'),
                      controller: TextEditingController(text: transaction.date),
                      readOnly: true,
                      onTap: () async {
                        DateTime initialDate = DateTime.now();
                        if (transaction.date != null &&
                            transaction.date!.isNotEmpty) {
                          initialDate = DateTime.parse(transaction.date!);
                        }
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: initialDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            transaction.date =
                                pickedDate.toIso8601String().split('T').first;
                          });
                        }
                      },
                      validator: (value) {
                        if (transaction.date == null ||
                            transaction.date!.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),

                    // Category Selection
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoriesLoaded) {
                          return DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                                labelText: 'Select Category'),
                            items: state.categories
                                .map(
                                  (category) => DropdownMenuItem<int>(
                                    value: category.id,
                                    child: Text(category.name),
                                  ),
                                )
                                .toList(),
                            value: transaction.categoryId != -1
                                ? transaction.categoryId
                                : null,
                            onChanged: (value) {
                              setState(() {
                                transaction.categoryId = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          );
                        } else if (state is CategoriesLoading) {
                          return const CircularProgressIndicator();
                        } else {
                          return const Text('Failed to load categories');
                        }
                      },
                    ),

                    // Memo
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Memo'),
                      initialValue: transaction.memo,
                      onChanged: (value) {
                        transaction.memo = value;
                      },
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Remove the notification and add the transaction
                          context.read<NotificationBloc>().add(
                                RemoveNotification(transaction: transaction),
                              );
                          Navigator.pop(context, transaction);
                        }
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
