import 'package:bloc/bloc.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_event.dart';
import 'package:fundflow/features/home/bloc/transaction/transaction_state.dart';
import 'package:fundflow/features/home/repository/transaction_repository.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionBloc({required this.transactionRepository})
      : super(TransactionsLoading()) {
    on<LoadTransactions>((event, emit) async {
      emit(TransactionsLoading());
      try {
        final data = await transactionRepository.getTransactions();
        emit(TransactionsLoaded(transactions: data['transactions']));
      } catch (error) {
        emit(TransactionsLoadError("Failed to load transaction history"));
      }
    });

    on<DeleteTransaction>((event, emit) async {
      try {
        await transactionRepository.deleteTransaction(event.transactionId);
        add(LoadTransactions());
        emit(TransactionDeleted());
      } catch (error) {
        emit(TransactionsLoading());
      }
    });
  }
}
