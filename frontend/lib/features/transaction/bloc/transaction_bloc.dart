import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/transaction/bloc/transaction_event.dart';
import 'package:fundflow/features/transaction/bloc/transaction_state.dart';
import '../repository/transaction_repository.dart';

class TransactionAddBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionAddRepository repository;

  TransactionAddBloc({required this.repository}) : super(TransactionInitial()) {
    on<FetchBanksAndCategories>(_onFetchBanksAndCategories);
    on<AddTransactionEvent>(_onAddTransaction);
    on<AddTransferEvent>(_onAddTransfer);
  }
  Future<void> _onFetchBanksAndCategories(
      FetchBanksAndCategories event, Emitter<TransactionState> emit) async {
    logger.d('Fetching banks and categories');
    emit(TransactionLoading());
    try {
      final banks = await repository.fetchBanks();
      final categories = await repository.fetchCategories();
      logger.d('Banks and categories loaded successfully');
      emit(BanksAndCategoriesLoaded(banks: banks, categories: categories));
    } catch (e) {
      logger.e('Failed to load banks and categories: $e');
      emit(TransactionFailure(e.toString()));
    }
  }

  Future<void> _onAddTransaction(
      AddTransactionEvent event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      await repository.addTransaction(event.transaction);
      emit(TransactionSuccess());
    } catch (e) {
      emit(TransactionFailure(e.toString()));
    }
  }

  Future<void> _onAddTransfer(
      AddTransferEvent event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      await repository.addTransfer(event.request);
      logger.d('Transfer added successfully');
      emit(TransactionSuccess());
    } catch (e) {
      logger.e('Failed to add transfer: $e');
      emit(TransactionFailure(e.toString()));
    }
  }
}
