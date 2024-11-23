// bloc/slip_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/image_upload/repository/slip_repository.dart';
import 'package:fundflow/features/transaction/model/category_model.dart';
import 'package:image_picker/image_picker.dart';
import 'slip_event.dart';
import 'slip_state.dart';

class SlipBloc extends Bloc<SlipEvent, SlipState> {
  final SlipRepository slipRepository;

  SlipBloc(this.slipRepository) : super(SlipInitial()) {
    on<DetectAndUploadSlips>(_onDetectAndUploadSlips);
    on<FetchCategories>(_onFetchCategories);
    on<ManualUploadSlips>(_onManualUploadSlips);
  }

  Future<void> _onDetectAndUploadSlips(
      DetectAndUploadSlips event, Emitter<SlipState> emit) async {
    emit(SlipLoading());
    try {
      // Fetch all categories
      List<Category> allCategories = await slipRepository.getCategories();

      // Fetch slip images
      List<XFile> slipImages = await slipRepository.filterSlipImages();

      if (slipImages.isEmpty) {
        logger.w('No slip images detected.');
        throw Exception('No slip images detected.');
      }

      // Determine categories to send based on identifiers
      // Assuming category name matches the identifiers
      // Collect categories whose name matches any of the identifiers

      List<Category> selectedCategories = allCategories.where((category) {
        return slipRepository.slipIdentifiers.any(
            (id) => category.name.toUpperCase().contains(id.toUpperCase()));
      }).toList();

      if (selectedCategories.isEmpty) {
        // If no specific categories match, optionally use a default category
        // For now, throw an exception
        throw Exception('No matching categories found for detected slips.');
      }

      await slipRepository.uploadDetectedSlips(selectedCategories);
      emit(SlipSuccess());
    } catch (e) {
      emit(SlipFailure(e.toString()));
    }
  }

  Future<void> _onFetchCategories(
      FetchCategories event, Emitter<SlipState> emit) async {
    emit(SlipLoading());
    try {
      List<Category> categories = await slipRepository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(SlipFailure(e.toString()));
    }
  }

  Future<void> _onManualUploadSlips(
      ManualUploadSlips event, Emitter<SlipState> emit) async {
    emit(SlipLoading());
    try {
      await slipRepository.manualUploadSlips(
        images: event.images,
        categories: event.categories,
      );
      emit(SlipSuccess());
    } catch (e) {
      emit(SlipFailure(e.toString()));
    }
  }
}
