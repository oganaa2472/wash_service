import '../entities/wash_employee.dart';
import '../repositories/wash_employee_repository.dart';

class GetWashEmployees {
  final WashEmployeeRepository repository;

  GetWashEmployees(this.repository);

  Future<List<WashEmployee>> call(String companyId) async {
    try {
      return await repository.getWashEmployees(companyId);
    } catch (e) {
      throw Exception('Failed to get wash employees: $e');
    }
  }
} 