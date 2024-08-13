part of 'food_by_category_bloc.dart';

sealed class FoodByCategoryEvent {}
class FetchFoodByLocationCodeAndCategoryIdEvent extends FoodByCategoryEvent{
  final int pageNumber;
  final int categoryId;
  FetchFoodByLocationCodeAndCategoryIdEvent({required this.pageNumber,required this.categoryId});
}