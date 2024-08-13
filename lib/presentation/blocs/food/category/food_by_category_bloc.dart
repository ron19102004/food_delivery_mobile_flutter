
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/datasource/models/food_model.dart';
import 'package:mobile/datasource/services/location_service.dart';

import '../../../../configs/dependency_injection.dart';
import '../../../../datasource/repositories/food_repository.dart';

part 'food_by_category_event.dart';
part 'food_by_category_state.dart';

class FoodByCategoryBloc extends Bloc<FoodByCategoryEvent, FoodByCategoryState> {
  FoodByCategoryBloc() : super(FoodByCategoryInitial()) {
    final FoodRepository foodRepository = di();
    on<FetchFoodByLocationCodeAndCategoryIdEvent>((event, emit) async {
      emit(FetchingByCategoryAndLocationCodeState());
      List<FoodModel> foods = await foodRepository
          .getFoodsByCategoryIdAndLocationCode(event.categoryId,LocationService.locationCodeCurrent, event.pageNumber);
      emit(FetchSuccessByCategoryAndLocationCodeState(foodsByLocationCodeAndCategory: foods));
    });
  }
}
