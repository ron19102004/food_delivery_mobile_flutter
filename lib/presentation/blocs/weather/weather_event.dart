part of 'weather_bloc.dart';

sealed class WeatherEvent {
}

class WeatherFetchEvent extends WeatherEvent {
  String lon;
  String lat;

  WeatherFetchEvent({required this.lat,required this.lon});
}