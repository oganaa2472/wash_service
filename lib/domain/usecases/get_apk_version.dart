import '../entities/apk_version.dart';
import '../repositories/version_repository.dart';

class GetApkVersion {
  final VersionRepository repository;

  GetApkVersion(this.repository);

  Future<ApkVersion?> call(int categoryId) async {
    return await repository.getApkVersion(categoryId);
  }
} 