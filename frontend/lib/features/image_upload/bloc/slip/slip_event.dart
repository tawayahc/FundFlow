import 'package:equatable/equatable.dart';

abstract class SlipEvent extends Equatable {
  const SlipEvent();

  @override
  List<Object?> get props => [];
}

class DetectAndUploadSlips extends SlipEvent {}

class FetchCategories extends SlipEvent {}
