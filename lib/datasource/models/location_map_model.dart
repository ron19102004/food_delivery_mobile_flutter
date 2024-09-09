class LocationModel {
  final int placeId;
  final String licence;
  final String osmType;
  final int osmId;
  final double latitude;
  final double longitude;
  final String roadClass;
  final String type;
  final int placeRank;
  final double importance;
  final String addresstype;
  final String name;
  final String displayName;
  final String code;

  LocationModel({
    required this.placeId,
    required this.licence,
    required this.osmType,
    required this.osmId,
    required this.latitude,
    required this.longitude,
    required this.roadClass,
    required this.type,
    required this.placeRank,
    required this.importance,
    required this.addresstype,
    required this.name,
    required this.displayName,
    required this.code
  });

  factory LocationModel.fromJson(Map<String, dynamic> json, double latitude, double longitude) {
    return LocationModel(
      placeId: json['place_id'],
      licence: json['licence'],
      osmType: json['osm_type'],
      osmId: json['osm_id'],
      latitude: latitude,
      longitude: longitude,
      roadClass: json['class'],
      type: json['type'],
      placeRank: json['place_rank'],
      importance: json['importance'].toDouble(),
      addresstype: json['addresstype'],
      name: json['name'],
      displayName: json['display_name'],
      code: json["address"]["ISO3166-2-lvl4"]
    );
  }
}