import '../entities/company.dart';
import '../repositories/company_repository.dart';

class FetchCompaniesByCategory {
  final CompanyRepository repository;
  FetchCompaniesByCategory(this.repository);

  Future<List<Company>> call(int categoryId) {
    return repository.fetchCompaniesByCategory(categoryId);
  }
}

class CreateCompany {
  final CompanyRepository repository;
  CreateCompany(this.repository);

  Future<bool> call({required String name, required String address, String? logo}) {
    return repository.createCompany(name: name, address: address, logo: logo);
  }
} 