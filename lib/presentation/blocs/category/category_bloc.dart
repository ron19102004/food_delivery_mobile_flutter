import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/datasource/models/category_model.dart';
import 'package:mobile/datasource/repositories/category_repository.dart';

import '../../../configs/dependency_injection.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    final CategoryRepository cr = di();
    on<FetchCategoryEvent>((event, emit) async {
      List<CategoryModel> ls = await cr.getCategories();
      emit(FetchSuccessCategoryState(list: ls));
    });
  }
}
