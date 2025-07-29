import '../../domain/entities/company.dart';

class CompanyModel {
  final String id;
  final String name;
  final String? logo;
  final String? point;
  final String? address;
  final CompanyCategoryModel? category;
  final List<AccountModel>? accounts;

  CompanyModel({
    required this.id,
    required this.name,
    this.logo,
    this.point,
    this.address,
    this.category,
    this.accounts,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    List<AccountModel>? accounts;
    if (json['accounts'] != null && json['accounts']['edges'] != null) {
      accounts = (json['accounts']['edges'] as List)
          .map((edge) => AccountModel.fromJson(edge['node']))
          .toList();
    }

    return CompanyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'],
      point: json['point'],
      address: json['address'],
      category: json['category'] != null
          ? CompanyCategoryModel.fromJson(json['category'])
          : null,
      accounts: accounts,
    );
  }

  Company toEntity() {
    return Company(
      id: id,
      name: name,
      logo: logo,
      point: point,
      address: address,
      category: category?.toEntity(),
      accounts: accounts?.map((account) => account.toEntity()).toList(),
    );
  }
}

class CompanyCategoryModel {
  final String id;
  final String name;
  CompanyCategoryModel({required this.id, required this.name});

  factory CompanyCategoryModel.fromJson(Map<String, dynamic> json) {
    return CompanyCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  CompanyCategory toEntity() {
    return CompanyCategory(id: id, name: name);
  }
}

class AccountModel {
  final String accountName;
  final String accountOwner;
  final String iban;
  final String account;

  AccountModel({
    required this.accountName,
    required this.accountOwner,
    required this.iban,
    required this.account,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      accountName: json['accountName'] ?? '',
      accountOwner: json['accountOwner'] ?? '',
      iban: json['iban'] ?? '',
      account: json['account'] ?? '',
    );
  }

  Account toEntity() {
    return Account(
      accountName: accountName,
      accountOwner: accountOwner,
      iban: iban,
      account: account,
    );
  }
} 