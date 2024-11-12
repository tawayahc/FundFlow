// import 'package:bloc/bloc.dart';
// import 'package:fundflow/features/home/bloc/transaction/transaction_event.dart';
// import 'package:fundflow/features/home/bloc/transaction/transaction_state.dart';
// import 'package:fundflow/features/home/repository/transaction_repository.dart';
//
// class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
//   final TransactionRepository transactionRepository;
//
//   TransactionBloc({required this.transactionRepository}) : super(TransactionsLoading()) {
//     on<LoadTransactions>((event, emit) async {
//       emit(TransactionsLoading());
//       try {
//         final transactions = await transactionRepository.getTransaction();
//         emit(TransactionsLoaded(category));
//       } catch (error) {
//         emit(TransactionsLoadError("Failed to load transaction history"));
//       }
//     });
//   }
//
// }
