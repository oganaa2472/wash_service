import '../../domain/entities/company.dart';
import '../../domain/repositories/company_repository.dart';
import '../datasources/company_remote_data_source.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource remoteDataSource;
  CompanyRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Company>> fetchCompaniesByCategory(int categoryId) async {
    final models = await remoteDataSource.fetchCompaniesByCategory(categoryId);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<bool> createCompany({required String name, required String address, String? logo}) {
    return remoteDataSource.createCompany(name: name, address: address, logo: logo);
  }
} 