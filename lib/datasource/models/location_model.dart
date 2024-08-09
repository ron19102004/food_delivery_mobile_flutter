class LocationModel {
  final int placeId;
  final String licence;
  final String osmType;
  final int osmId;
  final String latitude;
  final String longitude;
  final String roadClass;
  final String type;
  final int placeRank;
  final double importance;
  final String addresstype;
  final String name;
  final String displayName;

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
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      placeId: json['place_id'],
      licence: json['licence'],
      osmType: json['osm_type'],
      osmId: json['osm_id'],
      latitude: json['lat'],
      longitude: json['lon'],
      roadClass: json['class'],
      type: json['type'],
      placeRank: json['place_rank'],
      importance: json['importance'].toDouble(),
      addresstype: json['addresstype'],
      name: json['name'],
      displayName: json['display_name'],
    );
  }
}