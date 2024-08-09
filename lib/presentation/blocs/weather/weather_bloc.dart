import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/datasource/models/weather_model.dart';
import 'package:mobile/datasource/repositories/weather_repository.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherFetchEvent>((event, emit) async {
      try {
        WeatherRepository wr = WeatherRepository();
        WeatherModel weather =
            await wr.getWeatherByLatLon(event.lat, event.lon);
        emit(WeatherFetchSuccess(weather: weather));
      } catch (e) {
        print(e);
      }
    });
  }
}
