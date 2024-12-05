import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/models/category_model.dart';
import 'package:fundflow/features/overview/model/categorized_summary.dart';
import 'package:fundflow/features/overview/model/transaction_all_model.dart';
import 'package:fundflow/features/transaction/repository/transaction_repository.dart';
import 'categorized_event.dart';
import 'categorized_state.dart';

class CategorizedBloc extends Bloc<CategorizedEvent, CategorizedState> {
  final TransactionAddRepository repository;

  CategorizedBloc({required this.repository}) : super(CategorizedInitial()) {
    on<FetchCategorizedTransactionsEvent>(_onFetchCategorizedTransactions);
    on<ApplyFiltersEvent>(_onApplyFilters);
  }

  Future<void> _onFetchCategorizedTransactions(
      FetchCategorizedTransactionsEvent event,
      Emitter<CategorizedState> emit) async {
    emit(CategorizedLoading());
    try {
      // Note: If use fetchOnlyExpense it will not show income
      // Note: If use fetchCombinedTransactions it will show both
      final transactions = await repository.fetchOnlyExpense();
      logger
          .d('Fetched ${transactions.length} transactions for categorization.');

      // Extract unique categories from fetched transactions
      final categories = _extractCategories(transactions);
      final categorizedSummaries =
          _calculateCategorizedSummaries(transactions, categories);

      emit(CategorizedLoaded(
        categories: categories,
        categorizedSummaries: categorizedSummaries,
      ));
    } catch (e, stackTrace) {
      logger.e('Error fetching categorized transactions: $e , $stackTrace');
      emit(CategorizedError(message: e.toString()));
    }
  }

  List<Category> _extractCategories(List<TransactionAllModel> transactions) {
    final categorySet = <String>{};
    for (var tx in transactions) {
      categorySet.add(tx.categoryName.toLowerCase());
    }
    // Assuming category names are unique; otherwise, adjust accordingly
    return categorySet
        .map((category) => Category(
              id: 0, // Placeholder since id isn't used here
              name: category,
              color: Color(int.parse(
                  '0xFF000000')), // Placeholder, actual color is in TransactionAllModel
              amount: 0.0, // Placeholder
            ))
        .toList();
  }

  Map<String, CategorizedSummary> _calculateCategorizedSummaries(
      List<TransactionAllModel> transactions, List<Category> categories) {
    Map<String, CategorizedSummary> summaryMap = {};

    for (var tx in transactions) {
      final category = tx.categoryName.toLowerCase();
      if (!summaryMap.containsKey(category)) {
        summaryMap[category] = CategorizedSummary(
          category: tx.categoryName,
          totalIncome: 0.0,
          totalExpense: 0.0,
          categoryColor: tx.categoryColor,
        );
      }

      if (tx.type.toLowerCase() == 'income') {
        summaryMap[category]!.totalIncome += tx.amount;
      } else if (tx.type.toLowerCase() == 'expense') {
        summaryMap[category]!.totalExpense += tx.amount;
      }
    }

    return summaryMap;
  }

  Future<void> _onApplyFilters(
      ApplyFiltersEvent event, Emitter<CategorizedState> emit) async {
    emit(CategorizedLoading());
    try {
      final filteredTransactions = await repository.fetchFilteredTransactions(
        categoryName: event.categoryName,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      logger.d('Fetched ${filteredTransactions.length} filtered transactions.');

      // Extract unique categories from filtered transactions
      final categories = _extractCategories(filteredTransactions);
      final categorizedSummaries =
          _calculateCategorizedSummaries(filteredTransactions, categories);

      emit(CategorizedLoaded(
        categories: categories,
        categorizedSummaries: categorizedSummaries,
      ));
    } catch (e, stackTrace) {
      logger.e('Error applying filters: $e , $stackTrace');
      emit(CategorizedError(message: e.toString()));
    }
  }

  @override
  void onTransition(Transition<CategorizedEvent, CategorizedState> transition) {
    super.onTransition(transition);
    logger
        .d('Transition: ${transition.currentState} -> ${transition.nextState}');
  }
}
