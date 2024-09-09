class ResponseLayout<T> {
  final T? data;
  final String message;
  final bool status;
  ResponseLayout({required this.message,required this.status, this.data});
}