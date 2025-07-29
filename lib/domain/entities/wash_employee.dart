class WashEmployee {
  final String id;
  final String employeeId;
  final String skillPercentage;
  final bool isActive;
  final Employee employee;

  WashEmployee({
    required this.id,
    required this.employeeId,
    required this.skillPercentage,
    required this.isActive,
    required this.employee,
  });
}

class Employee {
  final String id;
  final String username;
  final String lastName;
  final String phone;
  final String email;
  final bool isMailVerified;
  final bool isPhoneVerified;

  Employee({
    required this.id,
    required this.username,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.isMailVerified,
    required this.isPhoneVerified,
  });
} 