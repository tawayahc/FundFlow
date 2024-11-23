// features/overview/bloc/overview_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/overview/model/transaction_all_model.dart';
import 'package:fundflow/features/transaction/repository/transaction_repository.dart';
import 'overview_event.dart';
import 'overview_state.dart';
import '../model/daily_summary.dart';
import '../model/monthly_summary.dart';
import '../model/summary.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  final TransactionAddRepository repository;

  OverviewBloc({required this.repository}) : super(OverviewInitial()) {
    on<FetchTransactionsEvent>(_onFetchTransactions);
  }

  Future<void> _onFetchTransactions(
      FetchTransactionsEvent event, Emitter<OverviewState> emit) async {
    emit(OverviewLoading());
    try {
      final transactions = await repository.fetchCombinedTransactions();
      final summary = _calculateSummary(transactions);
      final dailySummaries = _calculateDailySummaries(transactions);
      final monthlySummaries = _calculateMonthlySummaries(transactions);
      emit(OverviewLoaded(
        summary: summary,
        dailySummaries: dailySummaries,
        monthlySummaries: monthlySummaries,
      ));
      logger.i('OverviewLoaded');
    } catch (e) {
      logger.e("Error: $e");
      emit(OverviewError(message: e.toString()));
    }
  }

  Summary _calculateSummary(List<TransactionAllModel> transactions) {
    double totalIncome = 0.0;
    double totalExpense = 0.0;
    int incomeItems = 0;
    int expenseItems = 0;
    double avgIncomePerMonth = 0.0;
    double avgExpensePerMonth = 0.0;

    for (var tx in transactions) {
      if (tx.type.toLowerCase() == 'income') {
        totalIncome += tx.amount;
        incomeItems += 1;
      } else if (tx.type.toLowerCase() == 'expense') {
        totalExpense += tx.amount;
        expenseItems += 1;
      }
    }

    avgIncomePerMonth = totalIncome; // Adjust as needed
    avgExpensePerMonth = totalExpense; // Adjust as needed

    return Summary(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      incomeItems: incomeItems,
      expenseItems: expenseItems,
      avgIncomePerMonth: avgIncomePerMonth,
      avgExpensePerMonth: avgExpensePerMonth,
    );
  }

  Map<DateTime, DailySummary> _calculateDailySummaries(
      List<TransactionAllModel> transactions) {
    Map<DateTime, DailySummary> dailySummaryMap = {};

    for (var transaction in transactions) {
      final date = DateTime(
        transaction.createdAt.year,
        transaction.createdAt.month,
        transaction.createdAt.day,
      );

      dailySummaryMap.update(date, (summary) {
        double income = summary.totalIncome;
        double expense = summary.totalExpense;

        if (transaction.type.toLowerCase() == 'income') {
          income += transaction.amount;
        } else if (transaction.type.toLowerCase() == 'expense') {
          expense += transaction.amount;
        }

        return DailySummary(
          date: date,
          totalIncome: income,
          totalExpense: expense,
          netTotal: income - expense,
        );
      }, ifAbsent: () {
        double income = 0;
        double expense = 0;

        if (transaction.type.toLowerCase() == 'income') {
          income = transaction.amount;
        } else if (transaction.type.toLowerCase() == 'expense') {
          expense = transaction.amount;
        }

        return DailySummary(
          date: date,
          totalIncome: income,
          totalExpense: expense,
          netTotal: income - expense,
        );
      });
    }

    return dailySummaryMap;
  }

  Map<DateTime, MonthlySummary> _calculateMonthlySummaries(
      List<TransactionAllModel> transactions) {
    Map<DateTime, MonthlySummary> monthlySummaryMap = {};

    for (var transaction in transactions) {
      final month =
          DateTime(transaction.createdAt.year, transaction.createdAt.month);

      monthlySummaryMap.update(month, (summary) {
        double income = summary.totalIncome;
        double expense = summary.totalExpense;

        if (transaction.type.toLowerCase() == 'income') {
          income += transaction.amount;
        } else if (transaction.type.toLowerCase() == 'expense') {
          expense += transaction.amount;
        }

        return MonthlySummary(
          month: month,
          totalIncome: income,
          totalExpense: expense,
          netTotal: income - expense,
        );
      }, ifAbsent: () {
        double income = 0;
        double expense = 0;

        if (transaction.type.toLowerCase() == 'income') {
          income = transaction.amount;
        } else if (transaction.type.toLowerCase() == 'expense') {
          expense = transaction.amount;
        }

        return MonthlySummary(
          month: month,
          totalIncome: income,
          totalExpense: expense,
          netTotal: income - expense,
        );
      });
    }

    return monthlySummaryMap;
  }

  @override
  void onTransition(Transition<OverviewEvent, OverviewState> transition) {
    super.onTransition(transition);
    logger
        .d('Transition: ${transition.currentState} -> ${transition.nextState}');
  }
}
