import 'package:image_picker/image_picker.dart';

abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageLoadInProgress extends ImageState {}

class ImageLoadSuccess extends ImageState {
  final List<XFile> images;

  ImageLoadSuccess(this.images);
}

class ImageSendSuccess extends ImageState {}

class ImageOperationFailure extends ImageState {
  final String error;

  ImageOperationFailure(this.error);
}
