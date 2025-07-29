import '../entities/wash_service.dart';
import '../repositories/wash_service_repository.dart';

class GetWashServices {
  final WashServiceRepository repository;

  GetWashServices(this.repository);

  Future<List<WashService>> call(String companyId) async {
    try {
      return await repository.getWashServices(companyId);
    } catch (e) {
      throw Exception('Failed to get wash services: $e');
    }
  }
} 