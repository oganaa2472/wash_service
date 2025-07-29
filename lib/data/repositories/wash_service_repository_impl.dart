import '../../domain/entities/wash_service.dart';
import '../../domain/repositories/wash_service_repository.dart';
import '../datasources/wash_service_remote_data_source.dart';

class WashServiceRepositoryImpl implements WashServiceRepository {
  final WashServiceRemoteDataSource remoteDataSource;

  WashServiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<WashService>> getWashServices(String companyId) async {
    try {
      final serviceModels = await remoteDataSource.getWashServices(companyId);
      return serviceModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get wash services: $e');
    }
  }
} 