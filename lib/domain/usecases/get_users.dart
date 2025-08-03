import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<List<User>> call() async {
    return await repository.getUsers();
  }
}
