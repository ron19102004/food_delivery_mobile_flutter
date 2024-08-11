part of 'category_bloc.dart';

sealed class CategoryState {
  List<CategoryModel> getCategories() => [];
}

final class CategoryInitial extends CategoryState {}

class FetchSuccessCategoryState extends CategoryState{
  List<CategoryModel> list;
  FetchSuccessCategoryState({required this.list});
  @override
  List<CategoryModel> getCategories() {
    return list;
  }
}