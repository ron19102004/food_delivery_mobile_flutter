import 'package:bloc/bloc.dart';
import 'package:mobile/datasource/models/food_model.dart';
import 'package:mobile/datasource/repositories/food_repository.dart';
import 'package:mobile/datasource/services/location_service.dart';

import '../../../../configs/dependency_injection.dart';

part 'food_personal_event.dart';

part 'food_personal_state.dart';

class FoodPersonalBloc extends Bloc<FoodPersonalEvent, FoodPersonalState> {
  FoodPersonalBloc() : super(FoodPersonalInitial()) {
    final FoodRepository foodRepository = di();
    on<FetchFoodByLocationCodeEvent>((event, emit) async {
      emit(FetchingFoodByLocationCodeState());
      List<FoodModel> foods = await foodRepository
          .getFoodsByLocationCode(LocationService.locationCodeCurrent,event.pageNumber);
      emit(FetchSuccessFoodByLocationCodeState(foodsByLocationCode: foods));
    });

  }
}
