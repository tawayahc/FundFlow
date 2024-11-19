// image_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload_event.dart';
import 'package:fundflow/features/image_upload/bloc/image_upload_state.dart';
import 'package:fundflow/features/image_upload/repository/image_repository.dart';
import 'package:image_picker/image_picker.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository _imageRepository;
  List<XFile> _selectedImages = [];

  ImageBloc({required ImageRepository imageRepository})
      : _imageRepository = imageRepository,
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
    if (_selectedImages.isEmpty) {
      emit(ImageOperationFailure('No images selected to send.'));
      return;
    }

    try {
      emit(ImageLoadInProgress());
      await _imageRepository.uploadImages(_selectedImages);
      logger.i('Images sent successfully!');
      emit(ImageSendSuccess());
      _selectedImages.clear();
      emit(ImageLoadSuccess(List.from(_selectedImages))); // Emit cleared list
    } catch (e) {
      logger.e('Error sending images: $e');
      emit(ImageOperationFailure(e.toString()));
    }
  }
}
