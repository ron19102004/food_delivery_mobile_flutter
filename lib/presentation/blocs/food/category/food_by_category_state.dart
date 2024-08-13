part of 'food_by_category_bloc.dart';

sealed class FoodByCategoryState {
  List<FoodModel> getFoodsByLocationCode() => [];

}

final class FoodByCategoryInitial extends FoodByCategoryState {}

class FetchingByCategoryAndLocationCodeState extends FoodByCategoryState{}
class FetchSuccessByCategoryAndLocationCodeState extends FoodByCategoryState{
  List<FoodModel> foodsByLocationCodeAndCategory;

  FetchSuccessByCategoryAndLocationCodeState({required this.foodsByLocationCodeAndCategory});

  @override
  List<FoodModel> getFoodsByLocationCode() {
    return foodsByLocationCodeAndCategory;
  }
}