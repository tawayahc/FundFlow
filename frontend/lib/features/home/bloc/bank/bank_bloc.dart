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
        emit(BanksLoaded(banks: data['banks']));
      } catch (error) {
        emit(BankError());
      }
    });

    on<AddBank>((event, emit) async {
      try {
        // Save the bank (e.g., to a repository or API)
        await bankRepository.addBank(event.bank);
        add(LoadBanks());
        emit(BankAdded());
      } catch (error) {
        emit(BanksLoading());
      }
    });

    on<EditBank>((event, emit) async {
      try {
        // Edit the bank using the repository
        await bankRepository.editBank(event.originalBank, event.bank);
        // If successful, reload categories or navigate to the previous screen
        emit(BankUpdated());
      } catch (error) {
        print("Error editing bank: $error");
        emit(BankError()); // New error state
      }
    });

    on<DeleteBank>((event, emit) async {
      try {
        await bankRepository.deleteBank(event.bankId);
        add(LoadBanks());
        emit(BankDeleted());
      } catch (error) {
        emit(BankError());
      }
    });
  }
}
