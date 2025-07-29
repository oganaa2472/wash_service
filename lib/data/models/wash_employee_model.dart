import '../../domain/entities/wash_employee.dart' as domain;

class WashEmployeeModel {
  final String id;
  final String employeeId;
  final String skillPercentage;
  final bool isActive;
  final EmployeeModel employee;

  WashEmployeeModel({
    required this.id,
    required this.employeeId,
    required this.skillPercentage,
    required this.isActive,
    required this.employee,
  });

  factory WashEmployeeModel.fromJson(Map<String, dynamic> json) {
    return WashEmployeeModel(
      id: json['id'].toString() ?? '',
      employeeId: json['employeeId'].toString() ?? '',
      skillPercentage: json['skillPercentage'].toString() ?? '0',
      isActive: json['isActive'] ?? false,
      employee: EmployeeModel.fromJson(json['employee'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'skillPercentage': skillPercentage,
      'isActive': isActive,
      'employee': employee.toJson(),
    };
  }

  domain.WashEmployee toEntity() {
    return domain.WashEmployee(
      id: id,
      employeeId: employeeId,
      skillPercentage: skillPercentage,
      isActive: isActive,
      employee: employee.toEntity(),
    );
  }
}

class EmployeeModel {
  final String id;
  final String username;
  final String lastName;
  final String phone;
  final String email;
  final bool isMailVerified;
  final bool isPhoneVerified;

  EmployeeModel({
    required this.id,
    required this.username,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.isMailVerified,
    required this.isPhoneVerified,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'].toString() ?? '',
      username: json['username'].toString() ?? '',
      lastName: json['lastName'].toString() ?? '',
      phone: json['phone'].toString() ?? '',
      email: json['email'].toString() ?? '',
      isMailVerified: json['isMailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'isMailVerified': isMailVerified,
      'isPhoneVerified': isPhoneVerified,
    };
  }

  domain.Employee toEntity() {
    return domain.Employee(
      id: id,
      username: username,
      lastName: lastName,
      phone: phone,
      email: email,
      isMailVerified: isMailVerified,
      isPhoneVerified: isPhoneVerified,
    );
  }
} 