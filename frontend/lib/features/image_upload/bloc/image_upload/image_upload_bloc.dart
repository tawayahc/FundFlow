// image_bloc.dart
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload/image_upload_event.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload/image_upload_state.dart';
import 'package:fundflow/features/image_upload/repository/image_repository.dart';
import 'package:fundflow/features/image_upload/repository/slip_repository.dart';
import 'package:fundflow/features/transaction/model/bank_model.dart';
import 'package:fundflow/features/transaction/model/create_transaction_request_model.dart';
import 'package:fundflow/features/transaction/model/transaction.dart';
import 'package:fundflow/features/transaction/repository/transaction_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository _imageRepository;
  final TransactionAddRepository _transactionAddRepository;
  List<XFile> _selectedImages = [];

  ImageBloc({
    required ImageRepository imageRepository,
    required TransactionAddRepository transactionAddRepository,
  })  : _imageRepository = imageRepository,
        _transactionAddRepository = transactionAddRepository,
        super(ImageInitial()) {
    on<PickImages>(_onPickImages);
    on<RemoveImage>(_onRemoveImage);
    on<SendImages>(_onSendImages);
  }

  Future<void> _onPickImages(PickImages event, Emitter<ImageState> emit) async {
    try {
      final images = await _imageRepository.pickImages();
      if (images != null) {
        _selectedImages = images; // Replace existing list with new selection
        emit(ImageLoadSuccess(List.from(_selectedImages)));
      } else {
        emit(ImageOperationFailure('No images selected.'));
      }
    } catch (e) {
      logger.e('Error picking images: $e');
      emit(ImageOperationFailure(e.toString()));
    }
  }

  void _onRemoveImage(RemoveImage event, Emitter<ImageState> emit) {
    try {
      if (event.index >= 0 && event.index < _selectedImages.length) {
        _selectedImages.removeAt(event.index);
        emit(ImageLoadSuccess(List.from(_selectedImages)));
      } else {
        emit(ImageOperationFailure('Invalid image index.'));
      }
    } catch (e) {
      logger.e('Error removing image: $e');
      emit(ImageOperationFailure(e.toString()));
    }
  }

  Future<void> _onSendImages(SendImages event, Emitter<ImageState> emit) async {
    if (event.images.isEmpty) {
      emit(ImageOperationFailure('No images selected to send.'));
      return;
    }

    try {
      emit(ImageLoadInProgress());

      final transactions = await _imageRepository.uploadImages(
        images: event.images,
      );

      logger.i('Images sent successfully!');

      // Fetch user banks and categories once to optimize performance
      final userBanks = await _transactionAddRepository.fetchBanks();
      final categories = await _transactionAddRepository.fetchCategories();

      // Initialize list to collect transactions that need user confirmation
      List<TransactionResponse> transactionsToNotify = [];

      // Process each transaction
      for (var transaction in transactions) {
        bool needsUserAttention = false;

        // Check Condition 1: Duplicate Banks
        final matchingBanks = userBanks
            .where((bank) =>
                bank.bankName.toLowerCase() == transaction.bank.toLowerCase())
            .toList();

        if (matchingBanks.length >= 2) {
          needsUserAttention = true;
          // Attach matching banks to the transaction for user selection
          transaction.possibleBanks = matchingBanks;
        } else if (matchingBanks.isEmpty) {
          // No matching bank found
          needsUserAttention = true;
          transaction.possibleBanks = [];
        } else {
          // Single matching bank found
          transaction.bankId = matchingBanks.first.id;
        }

        // Check Condition 2: Null Date
        if (transaction.date == null || transaction.date!.isEmpty) {
          needsUserAttention = true;
        }

        // Check Condition 3: Category ID is -1
        if (transaction.categoryId == -1) {
          needsUserAttention = true;
          // Attach categories to the transaction for user selection
          transaction.possibleCategories = categories;
        }

        if (needsUserAttention) {
          transactionsToNotify.add(transaction);
        } else {
          final createTransactionRequest = CreateTransactionRequest(
            bankId: _getBankIdByName(transaction.bank, userBanks),
            type: transaction.type,
            amount: transaction.amount,
            categoryId: transaction.categoryId,
            createdAtDate: transaction.date!,
            createdAtTime: transaction.time,
            memo: transaction.memo,
            metadata: transaction.metadata,
          );
          // log Instance of 'createTransactionRequest' to console by mapping each transaction to json
          logger.d(
              'createTransactionRequest: ${jsonEncode(createTransactionRequest.toJson())}');
          await _transactionAddRepository
              .addTransaction(createTransactionRequest);
          logger.i('Transaction added successfully');
        }
      }

      // After processing all transactions, handle the ones that need user attention
      if (transactionsToNotify.isNotEmpty) {
        // Store transactions in local storage as notifications
        await _storeNotificationsLocally(transactionsToNotify);
        logger.d('Notifications stored locally: $transactionsToNotify');
        // log Instance of 'TransactionResponse' to console by mapping each transaction to json
        logger.d(
            'Notifications stored locally: ${transactionsToNotify.map((transaction) => jsonEncode(transaction.toJson()))}');

        emit(ImageSendSuccess(transactions: transactions));
      } else {
        // All transactions processed successfully
        emit(ImageSendSuccess(transactions: transactions));
      }
    } catch (e) {
      logger.e('Error sending images: $e');
      emit(ImageOperationFailure(e.toString()));
    }
  }

// Helper method to store notifications locally
  Future<void> _storeNotificationsLocally(
      List<TransactionResponse> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> existingNotifications =
        prefs.getStringList('notifications') ?? [];

    // Convert transactions to JSON strings
    List<String> newNotifications = transactions.map((transaction) {
      return jsonEncode(transaction.toJson());
    }).toList();

    // Combine existing and new notifications
    existingNotifications.addAll(newNotifications);

    // Save back to SharedPreferences
    await prefs.setStringList('notifications', existingNotifications);
  }
}

int _getBankIdByName(String bankName, List<Bank> userBanks) {
  final bank = userBanks.firstWhere(
    (bank) => bank.bankName.toLowerCase() == bankName.toLowerCase(),
    orElse: () => throw Exception('Bank not found: $bankName'),
  );
  return bank.id;
}
