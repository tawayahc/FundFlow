import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import '../repository/transaction_repository.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc({required this.repository}) : super(TransactionInitial()) {
    on<AddTransactionEvent>(_onAddTransaction);
  }

  void _onAddTransaction(
      AddTransactionEvent event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      await repository.addTransaction(event.transaction);
      emit(TransactionSuccess());
    } catch (e) {
      emit(TransactionFailure(e.toString()));
    }
  }
}
