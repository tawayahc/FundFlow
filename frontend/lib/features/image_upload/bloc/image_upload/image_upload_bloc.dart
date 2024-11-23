// image_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload/image_upload_event.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload/image_upload_state.dart';
import 'package:fundflow/features/image_upload/repository/image_repository.dart';
import 'package:fundflow/features/image_upload/repository/slip_repository.dart';
import 'package:fundflow/features/transaction/model/bank_model.dart';
import 'package:fundflow/features/transaction/model/create_transaction_request_model.dart';
import 'package:fundflow/features/transaction/repository/transaction_repository.dart';
import 'package:image_picker/image_picker.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository _imageRepository;
  final SlipRepository _slipRepository;
  final TransactionAddRepository _transactionAddRepository;
  List<XFile> _selectedImages = [];

  ImageBloc({
    required ImageRepository imageRepository,
    required SlipRepository slipRepository,
    required TransactionAddRepository transactionAddRepository,
  })  : _imageRepository = imageRepository,
        _slipRepository = slipRepository,
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

      // Fetch all user categories
      final categories = await _slipRepository.getCategories();

      if (categories.isEmpty) {
        emit(ImageOperationFailure('No categories available.'));
        return;
      }

      // Upload images with categories
      final transactions = await _imageRepository.uploadImages(
        images: event.images,
        categories: categories,
      );

      logger.i('Images sent successfully!');

      // Fetch user banks once to optimize performance
      final userBanks = await _transactionAddRepository.fetchBanks();

      // Process each transaction
      for (var transaction in transactions) {
        // Check if the transaction's bank matches any bank_name in userBanks
        final matchingBanks = userBanks
            .where((bank) =>
                bank.name.toLowerCase() == transaction.bank.toLowerCase())
            .toList();

        if (matchingBanks.length >= 2) {
          // User has two or more accounts with the same bank_name
          // Send to notification system
          // await _notificationRepository.sendNotification(transaction.toJson());
        } else {
          // Send to create transaction API
          final createTransactionRequest = CreateTransactionRequest(
            bankId: _getBankIdByName(
                transaction.bank, userBanks), // Implement this mapping
            type: transaction.type,
            amount: transaction.amount,
            categoryId:
                transaction.category, // Assuming 'category' maps to categoryId
            createdAtDate: transaction.date,
            createdAtTime: transaction.time,
            memo: transaction.memo,
          );

          await _transactionAddRepository
              .addTransaction(createTransactionRequest);
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
    final bank = userBanks.firstWhere(
      (bank) => bank.name.toLowerCase() == bankName.toLowerCase(),
      orElse: () => Bank(id: 0, name: 'Unknown'),
    );
    return bank.id;
  }
}
