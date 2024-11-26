// image_bloc.dart
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

      // Fetch user banks once to optimize performance
      final userBanks = await _transactionAddRepository.fetchBanks();
      // Note: model
      List<TransactionResponse> transactionsWithMultipleBanks = [];
      // Process each transaction
      for (var transaction in transactions) {
        final matchingBanks = userBanks
            .where((bank) =>
                bank.bankName.toLowerCase() == transaction.bank.toLowerCase())
            .toList();

        if (matchingBanks.length >= 2) {
          // TODO: Handle multiple banks for a single transaction
          transactionsWithMultipleBanks.add(transaction);

          // Log the transaction
          logger.d('Transaction with multiple banks: ${transaction.toJson()}');
          logger.d(
              "List of transactions with multiple banks: $transactionsWithMultipleBanks");
        } else if (matchingBanks.isEmpty) {
          // User does not have an account with the bank
          // Handle accordingly or log
          logger.w('No bank found for ${transaction.bank}');
          // Optionally, collect these transactions as well
        } else {
          // Send to create transaction API
          final createTransactionRequest = CreateTransactionRequest(
            bankId: _getBankIdByName(
                transaction.bank, userBanks), // Implement this mapping
            type: transaction.type,
            amount: transaction.amount,
            categoryId: transaction.categoryId,
            createdAtDate: transaction.date,
            createdAtTime: transaction.time,
            memo: transaction.memo,
            metadata: transaction.metadata,
          );

          await _transactionAddRepository
              .addTransaction(createTransactionRequest);
          logger.i('Transaction added successfully');
        }
      }

      emit(ImageSendSuccess(transactions: transactions));
      _selectedImages.clear();
      emit(ImageLoadSuccess(List.from(_selectedImages))); // Emit cleared list
    } catch (e) {
      logger.e('Error sending images: $e');
      emit(ImageOperationFailure(e.toString()));
    }
  }

  // Helper method to get bankId by bank name
  int _getBankIdByName(String bankName, List<Bank> userBanks) {
    // Find the first bank with the matching name and return its ID
    logger.d('Finding bank ID for: $bankName');
    logger.d('User banks: ${userBanks.map((bank) => bank.bankName).toList()}');
    final bank = userBanks.firstWhere(
      (bank) => bank.bankName.toLowerCase() == bankName.toLowerCase(),
      orElse: () => throw Exception('Bank not found: $bankName'),
    );
    logger.d('Bank found: ${bank.bankName} with ID: ${bank.id}');
    return bank.id;
  }
}
