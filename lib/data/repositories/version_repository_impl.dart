import '../../domain/entities/apk_version.dart';
import '../../domain/repositories/version_repository.dart';
import '../datasources/version_remote_data_source.dart';

class VersionRepositoryImpl implements VersionRepository {
  final VersionRemoteDataSource remoteDataSource;

  VersionRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApkVersion?> getApkVersion(int categoryId) async {
    try {
      return await remoteDataSource.getApkVersion(categoryId);
    } catch (e) {
      throw Exception('Failed to get APK version: $e');
    }
  }
} 