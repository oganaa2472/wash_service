import '../entities/company.dart';

abstract class CompanyRepository {
  Future<List<Company>> fetchCompaniesByCategory(int categoryId);
  Future<bool> createCompany({required String name, required String address, String? logo});
} 