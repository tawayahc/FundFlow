// category_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_event.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/features/home/repository/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository}) : super(CategorysLoading()) {
    // Registering the event handler
    on<LoadCategorys>((event, emit) async {
      emit(CategorysLoading());
      try {
        final data = await categoryRepository.getCategorys();
        emit(CategorysLoaded(
          cashBox: data['cashBox'],
          categorys: data['categorys'],
        ));
      } catch (error) {
        print("Error loading categories: $error");
        emit(CategoryError()); // New error state
      }
    });

    on<AddCategory>((event, emit) async {
      try {
        // Add the new category to the repository
        await categoryRepository.addCategory(Category(
          category: event.categoryName,
          amount: event.amount,
          color: event.color,
        ));
        // Reload categories after addition
        add(LoadCategorys());
      } catch (error) {
        emit(CategorysLoading()); // Handle error as needed
      }
    });
  }
}
