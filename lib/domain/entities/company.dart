class Company {
  final String id;
  final String name;
  final String? logo;
  final String? point;
  final String? address;
  final CompanyCategory? category;

  Company({
    required this.id,
    required this.name,
    this.logo,
    this.point,
    this.address,
    this.category,
  });
}

class CompanyCategory {
  final String id;
  final String name;
  CompanyCategory({required this.id, required this.name});
} 