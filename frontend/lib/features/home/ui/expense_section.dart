import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/expense_card.dart';
import 'package:fundflow/features/home/bloc/expense/expense_bloc.dart';
import 'package:fundflow/features/home/bloc/expense/expense_state.dart';
import 'package:fundflow/features/home/models/expense.dart';
import 'package:fundflow/core/widgets/home/cash_box.dart';

class ExpenseSection extends StatelessWidget {
  const ExpenseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpensesLoading) {
          return const CircularProgressIndicator();
        } else if (state is ExpensesLoaded) {
          return Column(
            children: [
              CashBox(cashBox: state.cashBox),
              const SizedBox(height: 10),
              ..._buildExpenseRows(state.expenses),
            ],
          );
        } else {
          return const Text('Error loading expenses');
        }
      },
    );
  }

  // Function to group expenses in pairs and return rows
  List<Widget> _buildExpenseRows(List<Expense> expenses) {
    List<Widget> rows = [];

    for (int i = 0; i < expenses.length; i += 2) {
      List<Widget> rowChildren = [];

      // First card
      rowChildren.add(
        Expanded(
          child: ExpenseCard(expense: expenses[i]),
        ),
      );

      // Second card or a spacer if only one card in the row
      if (i + 1 < expenses.length) {
        rowChildren.add(const SizedBox(width: 10)); // Space between cards
        rowChildren.add(
          Expanded(
            child: ExpenseCard(expense: expenses[i + 1]),
          ),
        );
      } else {
        rowChildren.add(const SizedBox(width: 10)); // Space for consistency
        rowChildren.add(
          const Spacer(), // Spacer to keep the single card at half width
        );
      }

      // Add the row with the two cards (or one card + spacer)
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowChildren,
          ),
        ),
      );
    }

    return rows;
  }
}
