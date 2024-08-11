String address_url(double lat,double lon){
  return "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json";
}
String weather_url(String lat,String lon){
  return "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true";
}
String my_api_url(String route){
  return "https://546e-103-172-79-198.ngrok-free.app/$route";
}
