import '../../domain/entities/wash_employee.dart';
import '../../domain/repositories/wash_employee_repository.dart';
import '../datasources/wash_employee_remote_data_source.dart';

class WashEmployeeRepositoryImpl implements WashEmployeeRepository {
  final WashEmployeeRemoteDataSource remoteDataSource;

  WashEmployeeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<WashEmployee>> getWashEmployees(String companyId) async {
    try {
      final employeeModels = await remoteDataSource.getWashEmployees(companyId);
      return employeeModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get wash employees: $e');
    }
  }
} 