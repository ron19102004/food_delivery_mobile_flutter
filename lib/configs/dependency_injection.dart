import 'package:get_it/get_it.dart';
import 'package:mobile/datasource/repositories/category_repository.dart';
import 'package:mobile/datasource/repositories/food_repository.dart';
import 'package:mobile/datasource/repositories/location_repository.dart';
import 'package:mobile/datasource/repositories/voucher_repository.dart';
import 'package:mobile/datasource/repositories/weather_repository.dart';
import 'package:mobile/datasource/services/location_service.dart';

final di = GetIt.instance;

Future<void> initializeDI() async {
  di.registerSingleton(WeatherRepository());
  di.registerSingleton(LocationRepository());
  di.registerSingleton(FoodRepository());
  di.registerSingleton(CategoryRepository());
  di.registerSingleton(VoucherRepository());
  di.registerFactory(() => LocationService(locationRepository: di()));
}
