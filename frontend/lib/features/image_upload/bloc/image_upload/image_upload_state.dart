import 'package:fundflow/features/transaction/model/transaction.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageLoadInProgress extends ImageState {}

class ImageLoadSuccess extends ImageState {
  final List<XFile> images;

  ImageLoadSuccess(this.images);
}

class ImageSendSuccess extends ImageState {
  final List<TransactionResponse> transactions;

  ImageSendSuccess({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class ImageOperationFailure extends ImageState {
  final String error;

  ImageOperationFailure(this.error);
}

class SlipDetectionInitial extends ImageState {}

class SlipDetectionLoading extends ImageState {}

class SlipDetectionSuccess extends ImageState {
  final String message;

  SlipDetectionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SlipDetectionFailure extends ImageState {
  final String error;

  SlipDetectionFailure(this.error);

  @override
  List<Object> get props => [error];
}
