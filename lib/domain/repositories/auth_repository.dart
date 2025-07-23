import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> requestOtp({
    required String contact,
    required bool isPhone,
  });

  Future<Either<Failure, User>> verifyOtp({
    required String contact,
    required String otp,
    required bool isPhone,
  });

  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, User>> getCurrentUser();
} 