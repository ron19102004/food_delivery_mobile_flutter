class UserModel {
  final int id;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phoneNumber;
  final String avatar;
  final String role;
  final bool enabledTwoFactorAuth;
  final bool isLocked;

  UserModel({
    required this.id,
    required this.updatedAt,
    required this.createdAt,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.avatar,
    required this.role,
    required this.enabledTwoFactorAuth,
    required this.isLocked,
  });

  // Factory constructor to create an instance from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt']),
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      avatar: json['avatar'],
      role: json['role'],
      enabledTwoFactorAuth: json['enabled_two_factor_auth'],
      isLocked: json['is_locked'],
    );
  }
}
