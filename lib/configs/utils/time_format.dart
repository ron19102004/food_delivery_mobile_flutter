String timeFormat(String? time) {
  if (time == null) return "";
  final list = time.split(":");
  return "${list[0]}:${list[1]}";
}
