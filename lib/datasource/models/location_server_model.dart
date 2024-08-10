class LocationServerModel {
  final String code;
  final String name;

  LocationServerModel({
    required this.code,
    required this.name,
  });

  // Factory constructor to create an instance from JSON
  factory LocationServerModel.fromJson(Map<String, dynamic> json) {
    return LocationServerModel(
      code: json['code'],
      name: json['name'],
    );
  }
}