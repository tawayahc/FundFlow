// bank_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/features/home/bloc/bank/bank_event.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';
import 'package:fundflow/features/home/repository/bank_repository.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  final BankRepository bankRepository;

  BankBloc({required this.bankRepository}) : super(BanksLoading()) {
    // Registering the handler for LoadBanks event
    on<LoadBanks>((event, emit) async {
      emit(BanksLoading());
      try {
        final data = await bankRepository.getBanks();
        emit(BanksLoaded(banks: data));
      } catch (error) {
        emit(BankError("Failed to load banks"));
      }
    });
  }
}
