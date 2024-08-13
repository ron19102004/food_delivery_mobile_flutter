part of 'food_by_seller_bloc.dart';

sealed class FoodBySellerEvent {}
class FetchFoodBySellerIdEvent extends FoodBySellerEvent{
  final int page;
  final int sellerId;
  FetchFoodBySellerIdEvent({required this.sellerId, required this.page});
}