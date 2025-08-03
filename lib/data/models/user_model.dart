import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String? id,
    required String? username,
    required String? email,
    required String? phone,
    required String? lastName,
  }) : super(
          id: id,
          username: username,
          email: email,
          phone: phone,
          lastName: lastName
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
        lastName: json['lastName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
    };
  }

  factory UserModel.fromAuthResponse(Map<String, dynamic> json) {
    final userData = json['user'] as Map<String, dynamic>;
    return UserModel.fromJson(userData);
  }
}
