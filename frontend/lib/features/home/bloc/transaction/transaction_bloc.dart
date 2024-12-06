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
        final currentState = state;
        if (currentState is TransactionsLoaded) {
          final transaction = currentState.transactions.firstWhere(
            (t) => t.id == event.transactionId,
            orElse: () => throw Exception("Transaction not found"),
          );

          if (transaction == null) {
            emit(TransactionsLoadError("Transaction not found"));
            return;
          }

          final bankId = transaction.bankId;
          final categoryId = transaction.categoryId;
          final amount = transaction.amount;
          final type = transaction.type;

          final bank = await transactionRepository.getBankById(bankId);
          double newBankAmount = bank.amount;

          if (type == 'income') {
            newBankAmount -= amount;
          } else if (type == 'expense') {
            newBankAmount += amount;
          }

          await transactionRepository.updateBankAmount(bankId, newBankAmount);

          if (type == 'expense' && categoryId != 0) {
            final category =
                await transactionRepository.getCategoryById(categoryId);
            double newCategoryAmount = category.amount + amount;

            await transactionRepository.updateCategoryAmount(
                categoryId, newCategoryAmount);
          }

          await transactionRepository.deleteTransaction(event.transactionId);

          add(LoadTransactions());
          emit(TransactionDeleted());
        } else {
          emit(TransactionsLoadError("Transactions not loaded"));
        }
      } catch (error) {
        emit(TransactionsLoadError("Failed to delete transaction: $error"));
      }
    });
  }
}
