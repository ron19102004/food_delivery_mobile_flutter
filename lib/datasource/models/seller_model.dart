class SellerModel {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String email;
  final String backgroundImage;
  final String avatar;
  final String openAt;
  final String closeAt;

  SellerModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.email,
    required this.backgroundImage,
    required this.avatar,
    required this.openAt,
    required this.closeAt,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      phoneNumber: json['phone_number'],
      email: json['email'],
      backgroundImage: json['background_image'],
      avatar: json['avatar'],
      openAt: json['open_at'],
      closeAt: json['close_at'],
    );
  }
}
