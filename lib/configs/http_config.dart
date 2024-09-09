String address_url(double lat,double lon){
  return "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json";
}
String weather_url(double lat,double lon){
  return "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true";
}
String my_api_url(String route){
  return "https://d0f3-2401-d800-553b-c743-1555-7e73-91ee-13f6.ngrok-free.app/$route";
}
