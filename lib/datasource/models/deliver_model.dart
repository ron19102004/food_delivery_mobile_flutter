class DeliverModel {
  final int id;
  final String name;
  final String phoneNumber;
  final String email;
  final String avatar;
  final String issuedAt;
  final bool enabled;

  DeliverModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.avatar,
    required this.issuedAt,
    required this.enabled,
  });

  factory DeliverModel.fromJson(Map<String, dynamic> json) {
    return DeliverModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      avatar: json['avatar'],
      issuedAt: json['issued_at'],
      enabled: json['enabled'],
    );
  }
}
