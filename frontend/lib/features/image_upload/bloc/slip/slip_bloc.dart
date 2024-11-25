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
  }

  Future<void> _onDetectAndUploadSlips(
      DetectAndUploadSlips event, Emitter<SlipState> emit) async {
    emit(SlipLoading());
    try {
      // Fetch slip images
      List<XFile> slipImages = await slipRepository.getSlipImages();

      if (slipImages.isEmpty) {
        logger.w('No slip images detected.');
        throw Exception('No slip images detected.');
      }
      await slipRepository.uploadDetectedSlips();
      emit(SlipSuccess());
    } catch (e) {
      logger.e('Error detecting and uploading slips: $e');
      emit(SlipFailure(e.toString()));
    }
  }
}
