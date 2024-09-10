String address_url(double lat,double lon){
  return "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json";
}
String weather_url(double lat,double lon){
  return "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true";
}
String my_api_url(String route){
  return "https://d2b6-2401-d800-553b-c743-d2f-7451-9ba0-807.ngrok-free.app/$route";
}
