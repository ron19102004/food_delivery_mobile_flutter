part of 'food_personal_bloc.dart';

sealed class FoodPersonalState {
  List<FoodModel> getFoodsByLocationCode() => [];
}

final class FoodPersonalInitial extends FoodPersonalState {}
class FetchingFoodByLocationCodeState extends FoodPersonalState{}
class FetchSuccessFoodByLocationCodeState extends FoodPersonalState {
  List<FoodModel> foodsByLocationCode;

  FetchSuccessFoodByLocationCodeState({required this.foodsByLocationCode});

  @override
  List<FoodModel> getFoodsByLocationCode() {
    return foodsByLocationCode;
  }
}
