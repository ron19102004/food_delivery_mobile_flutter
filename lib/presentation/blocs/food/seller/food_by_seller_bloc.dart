
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/datasource/models/food_model.dart';
import 'package:mobile/datasource/repositories/food_repository.dart';

import '../../../../configs/dependency_injection.dart';

part 'food_by_seller_event.dart';
part 'food_by_seller_state.dart';

class FoodBySellerBloc extends Bloc<FoodBySellerEvent, FoodBySellerState> {
  FoodBySellerBloc() : super(FoodBySellerInitial()) {
    final FoodRepository foodRepository = di();
    on<FetchFoodBySellerIdEvent>((event, emit) async{
      emit(FetchingBySellerIdState());
      List<FoodModel> foods = await foodRepository
          .getFoodsBySellerId(event.sellerId, event.page);
      emit(FetchSuccessBySellerIdState(list: foods));
    });
  }
}
