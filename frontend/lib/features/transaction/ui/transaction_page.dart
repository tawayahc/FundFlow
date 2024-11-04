// ui/transaction_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/features/transaction/widgets/tab_item.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../model/transaction_model.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with SingleTickerProviderStateMixin {
  String _type = 'income';
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();
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
    _amountController.dispose();
    _categoryController.dispose();
    _noteController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _submitTransaction() {
    if (_type != 'transfer') {
      final transaction = Transaction(
        userId: '', // Generate or assign an ID as needed
        type: _type,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        category: _categoryController.text,
        note: _noteController.text,
        date: DateTime.now(),
      );
      context.read<TransactionBloc>().add(AddTransactionEvent(transaction));
    } else {
      // FIXME : Transfer functionality to be implemented later
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Transaction'),
        ),
        body: BlocListener<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Transaction added successfully')),
              );
              _amountController.clear();
              _categoryController.clear();
              _noteController.clear();
            } else if (state is TransactionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: 200,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: AppColors.primary,
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            indicator: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white,
                            tabs: [
                              TabItem(
                                icon: Icons.download,
                              ),
                              TabItem(
                                icon: Icons.upload,
                              ),
                              TabItem(
                                icon: Icons.compare_arrows,
                              ),
                            ],
                          ),
                        ),
                        Container(
                            // image upload
                            )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.medium),
                if (_type != 'transfer') ...[
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  // FIX: this should be selct option or not
                  TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: 'Category'),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(labelText: 'Note'),
                  ),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitTransaction,
                  child: Text('Submit'),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/gallery');
                  },
                  icon: const Icon(Icons.photo),
                  label: const Text('gallery'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppBorders.medium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
