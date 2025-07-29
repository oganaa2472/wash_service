import '../entities/wash_service.dart';

abstract class WashServiceRepository {
  Future<List<WashService>> getWashServices(String companyId);
} 