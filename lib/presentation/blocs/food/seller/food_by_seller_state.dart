part of 'food_by_seller_bloc.dart';

sealed class FoodBySellerState {
  List<FoodModel> getFoodsByLocationCode() => [];
}

final class FoodBySellerInitial extends FoodBySellerState {}
class FetchingBySellerIdState extends FoodBySellerState {
}
class FetchSuccessBySellerIdState extends FoodBySellerState {
  List<FoodModel> list;
  FetchSuccessBySellerIdState({required this.list});
  @override
  List<FoodModel> getFoodsByLocationCode() {
    return list;
  }
}