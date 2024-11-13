import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_event.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/features/home/pages/home_page.dart';

class TransferCategoryAmount extends StatelessWidget {
  final Category fromCategory;
  final Category toCategory;

  const TransferCategoryAmount({
    Key? key,
    required this.fromCategory,
    required this.toCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    bool isCashBoxInvolved(Category category) => category.id == -1;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryTransferred || state is CategoryAmountUpdated) {
            // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //     content: Text('Category updated successfully')));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const GlobalPadding(child: HomePage())),
            );
            // Navigator.pop(context);
          } else if (state is CategoryError) {
            // Handle error state, show a SnackBar for example
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load categories')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transfer from: ${fromCategory.name} to: ${toCategory.name}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Transfer Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(amountController.text);
                    if (amount != null && amount > 0) {
                      if (isCashBoxInvolved(fromCategory)) {
                        BlocProvider.of<CategoryBloc>(context).add(
                          UpdateAmount(
                            categoryId: toCategory.id,
                            newAmount: toCategory.amount + amount,
                          ),
                        );
                      } else if (isCashBoxInvolved(toCategory)) {
                        BlocProvider.of<CategoryBloc>(context).add(
                          UpdateAmount(
                            categoryId: fromCategory.id,
                            newAmount: fromCategory.amount - amount,
                          ),
                        );
                      } else {
                        BlocProvider.of<CategoryBloc>(context).add(
                          TransferAmount(
                            fromCategoryId: fromCategory.id,
                            toCategoryId: toCategory.id,
                            amount: amount,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Transfer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
