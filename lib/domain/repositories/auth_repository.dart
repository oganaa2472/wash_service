import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String name, String email, String password, String phoneNumber);
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, User>> getCurrentUser();
} 