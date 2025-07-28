class Category {
  final String id;
  final String name;
  final int order;
  final String icon;
  final String description;
  final DateTime createdAt;
  final DateTime? deleteDate;

  const Category({
    required this.id,
    required this.name,
    required this.order,
    required this.icon,
    required this.description,
    required this.createdAt,
    this.deleteDate,
  });
} 