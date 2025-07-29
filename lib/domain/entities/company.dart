class Company {
  final String id;
  final String name;
  final String? logo;
  final String? point;
  final String? address;
  final CompanyCategory? category;
  final List<Account>? accounts;

  Company({
    required this.id,
    required this.name,
    this.logo,
    this.point,
    this.address,
    this.category,
    this.accounts,
  });
}

class CompanyCategory {
  final String id;
  final String name;
  CompanyCategory({required this.id, required this.name});
}

class Account {
  final String accountName;
  final String accountOwner;
  final String iban;
  final String account;

  Account({
    required this.accountName,
    required this.accountOwner,
    required this.iban,
    required this.account,
  });
} 