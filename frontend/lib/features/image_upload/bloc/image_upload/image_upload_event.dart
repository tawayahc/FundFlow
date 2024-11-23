// image_event.dart
import 'package:fundflow/features/transaction/model/category_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImageEvent {}

class PickImages extends ImageEvent {}

class RemoveImage extends ImageEvent {
  final int index;

  RemoveImage(this.index);
}

class SendImages extends ImageEvent {
  final List<XFile> images;

  SendImages({required this.images});

  @override
  List<Object?> get props => [images];
}

class HomePageOpened extends ImageEvent {}
