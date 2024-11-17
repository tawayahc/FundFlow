import 'package:bloc/bloc.dart';
import 'package:fundflow/features/home/repository/category_repository.dart';
import 'package:fundflow/features/home/repository/transaction_repository.dart';
import '../../home/repository/bank_repository.dart';
import 'overview_event.dart';
import 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  final BankRepository bankRepository;
  final CategoryRepository categoryRepository;
  final TransactionRepository transactionRepository;

  OverviewBloc({required this.bankRepository, required this.transactionRepository, required this.categoryRepository})
      : super(OverviewLoading());
}
