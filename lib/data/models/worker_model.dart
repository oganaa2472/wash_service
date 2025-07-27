import '../../domain/entities/worker.dart';

class WorkerModel extends Worker {
  WorkerModel({required int id, required String name, String? avatar}) : super(id: id, name: name, avatar: avatar);

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
      };
} 