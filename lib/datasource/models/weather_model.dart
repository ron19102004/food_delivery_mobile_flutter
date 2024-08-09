class WeatherModel {
  final double latitude;
  final double longitude;
  final double generationTimeMs;
  final int utcOffsetSeconds;
  final String timezone;
  final String timezoneAbbreviation;
  final double elevation;
  final String timeUnit;
  final String intervalUnit;
  final String temperatureUnit;
  final String windspeedUnit;
  final String winddirectionUnit;
  final String isDayUnit;
  final String weathercodeUnit;
  final String time;
  final int interval;
  final double temperature;
  final double windspeed;
  final int winddirection;
  final int isDay;
  final int weathercode;

  WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.generationTimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.timeUnit,
    required this.intervalUnit,
    required this.temperatureUnit,
    required this.windspeedUnit,
    required this.winddirectionUnit,
    required this.isDayUnit,
    required this.weathercodeUnit,
    required this.time,
    required this.interval,
    required this.temperature,
    required this.windspeed,
    required this.winddirection,
    required this.isDay,
    required this.weathercode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      generationTimeMs: json['generationtime_ms'],
      utcOffsetSeconds: json['utc_offset_seconds'],
      timezone: json['timezone'],
      timezoneAbbreviation: json['timezone_abbreviation'],
      elevation: json['elevation'],
      timeUnit: json['current_weather_units']['time'],
      intervalUnit: json['current_weather_units']['interval'],
      temperatureUnit: json['current_weather_units']['temperature'],
      windspeedUnit: json['current_weather_units']['windspeed'],
      winddirectionUnit: json['current_weather_units']['winddirection'],
      isDayUnit: json['current_weather_units']['is_day'],
      weathercodeUnit: json['current_weather_units']['weathercode'],
      time: json['current_weather']['time'],
      interval: json['current_weather']['interval'],
      temperature: json['current_weather']['temperature'],
      windspeed: json['current_weather']['windspeed'],
      winddirection: json['current_weather']['winddirection'],
      isDay: json['current_weather']['is_day'],
      weathercode: json['current_weather']['weathercode'],
    );
  }
}
