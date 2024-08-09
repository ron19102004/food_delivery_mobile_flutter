import 'package:get_it/get_it.dart';
import 'package:mobile/datasource/repositories/location_repository.dart';
import 'package:mobile/datasource/repositories/weather_repository.dart';
import 'package:mobile/datasource/services/location_service.dart';

final di = GetIt.instance;

Future<void> initializeDI() async {
  di.registerSingleton(WeatherRepository());
  di.registerSingleton(LocationRepository());
  di.registerFactory(() => LocationService(locationRepository: di()));
}
