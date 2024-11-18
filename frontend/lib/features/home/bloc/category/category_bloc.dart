// category_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_event.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/repository/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository})
      : super(CategoriesLoading()) {
    // Registering the event handler
    on<LoadCategories>((event, emit) async {
      emit(CategoriesLoading());
      try {
        final data = await categoryRepository.getCategories();
        emit(CategoriesLoaded(
          cashBox: data['cashBox'],
          categories: data['categories'],
        ));
      } catch (error) {
        print("Error loading categories: $error");
        emit(CategoryError()); // New error state
      }
    });

    on<AddCategory>((event, emit) async {
      try {
        // Add the new category to the repository
        await categoryRepository.addCategory(event.category);
        // Reload categories after addition
        add(LoadCategories());
        emit(CategoryAdded());
      } catch (error) {
        emit(CategoriesLoading()); // Handle error as needed
      }
    });

    on<EditCategory>((event, emit) async {
      try {
        // Edit the category using the repository
        await categoryRepository.editCategory(
            event.originalCategory, event.category);
        // If successful, reload categories or navigate to the previous screen
        emit(CategoryUpdated());
      } catch (error) {
        print("Error editing category: $error");
        emit(CategoryError()); // New error state
      }
    });

    on<TransferAmount>((event, emit) async {
      try {
        // Add the new category to the repository
        await categoryRepository.transferAmount(
            event.fromCategoryId, event.toCategoryId, event.amount);
        // Reload categories after addition
        add(LoadCategories());
        emit(CategoryTransferred());
      } catch (error) {
        emit(CategoriesLoading()); // Handle error as needed
      }
    });

    on<UpdateAmount>((event, emit) async {
      try {
        // Edit the category using the repository
        await categoryRepository.updateCategoryAmount(
            event.categoryId, event.newAmount);
        // If successful, reload categories or navigate to the previous screen
        emit(CategoryAmountUpdated());
      } catch (error) {
        print("Error updated category: $error");
        emit(CategoryError()); // New error state
      }
    });
  }
}
