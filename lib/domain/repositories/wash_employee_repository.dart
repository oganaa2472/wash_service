import '../entities/wash_employee.dart';

abstract class WashEmployeeRepository {
  Future<List<WashEmployee>> getWashEmployees(String companyId);
} 