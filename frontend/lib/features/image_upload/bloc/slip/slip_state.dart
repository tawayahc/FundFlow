import 'package:equatable/equatable.dart';
import 'package:fundflow/models/category_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class SlipState extends Equatable {
  const SlipState();

  @override
  List<Object?> get props => [];
}

class SlipInitial extends SlipState {}

class SlipLoading extends SlipState {}

class SlipSuccess extends SlipState {
  final List<XFile> images;

  const SlipSuccess({required this.images});
}

class SlipFailure extends SlipState {
  final String error;

  const SlipFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class CategoriesLoaded extends SlipState {
  final List<Category> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}
