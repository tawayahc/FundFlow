// bank_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/home/bloc/bank/bank_event.dart';
import 'package:fundflow/features/home/bloc/bank/bank_state.dart';
import 'package:fundflow/features/home/models/transaction.dart';
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

    on<LoadTransfers>((event, emit) async {
      emit(TransfersLoading());
      try {
        final transfers = await bankRepository.getTransfers();
        emit(TransfersLoaded(transfers: transfers));
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
        // If successful, reload banks or navigate to the previous screen
        emit(BankUpdated());
      } catch (error) {
        print("Error editing bank: $error");
        emit(BankError()); // New error state
      }
    });

    on<DeleteBank>((event, emit) async {
      try {
        final transactionMap =
            await bankRepository.getBankTransactions(event.bankId);
        final transactions = transactionMap['transactions'] ?? <Transaction>[];

        logger.i('Found ${transactions.length} transactions to delete.');

        for (final transaction in transactions) {
          await bankRepository.deleteTransaction(transaction.id);
          logger.i('Deleted transaction with ID: ${transaction.id}');
        }

        await bankRepository.deleteBank(event.bankId);
        logger.i('Deleted bank with ID: ${event.bankId}');

        add(LoadBanks());
        emit(BankDeleted());
      } catch (error) {
        logger.e('Error deleting bank: $error');
        emit(BanksLoading());
      }
    });
  }
}
