// image_event.dart
abstract class ImageEvent {}

class PickImages extends ImageEvent {}

class RemoveImage extends ImageEvent {
  final int index;

  RemoveImage(this.index);
}

class SendImages extends ImageEvent {}
