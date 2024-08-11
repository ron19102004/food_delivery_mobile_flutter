part of 'food_personal_bloc.dart';

sealed class FoodPersonalEvent {}
class FetchFoodByLocationCodeEvent extends FoodPersonalEvent{
  final int pageNumber;
  FetchFoodByLocationCodeEvent({required this.pageNumber});
}
