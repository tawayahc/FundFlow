// features/overview/model/summary.dart
class Summary {
  final double totalIncome;
  final double totalExpense;
  final int incomeItems;
  final int expenseItems;
  final double avgIncomePerMonth;
  final double avgExpensePerMonth;

  Summary({
    required this.totalIncome,
    required this.totalExpense,
    required this.incomeItems,
    required this.expenseItems,
    required this.avgIncomePerMonth,
    required this.avgExpensePerMonth,
  });
}
