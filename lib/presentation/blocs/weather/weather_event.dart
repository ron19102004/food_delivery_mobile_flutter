part of 'weather_bloc.dart';

sealed class WeatherEvent {
}

class WeatherFetchEvent extends WeatherEvent {
  double lon;
  double lat;

  WeatherFetchEvent({required this.lat,required this.lon});
}