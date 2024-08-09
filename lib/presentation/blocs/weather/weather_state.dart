part of 'weather_bloc.dart';

sealed class WeatherState {
  WeatherModel? getWeather() => null;
}

final class WeatherInitial extends WeatherState {}

class WeatherFetchSuccess extends WeatherState{
  WeatherModel weather;
  WeatherFetchSuccess({required this.weather});
  @override
  WeatherModel? getWeather() {
    return weather;
  }
}
