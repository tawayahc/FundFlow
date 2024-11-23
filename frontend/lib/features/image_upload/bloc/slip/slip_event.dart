import 'package:equatable/equatable.dart';
import 'package:fundflow/features/transaction/model/category_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class SlipEvent extends Equatable {
  const SlipEvent();

  @override
  List<Object?> get props => [];
}

class DetectAndUploadSlips extends SlipEvent {}

class FetchCategories extends SlipEvent {}

class ManualUploadSlips extends SlipEvent {
  final List<XFile> images;
  final List<Category> categories;

  const ManualUploadSlips({
    required this.images,
    required this.categories,
  });

  @override
  List<Object?> get props => [images, categories];
}
