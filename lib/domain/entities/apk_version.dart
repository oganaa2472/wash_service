import 'category.dart';

class ApkVersion {
  final String id;
  final String version;
  final DateTime updatedAt;
  final Category category;

  const ApkVersion({
    required this.id,
    required this.version,
    required this.updatedAt,
    required this.category,
  });
} 