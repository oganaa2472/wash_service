import '../entities/apk_version.dart';

abstract class VersionRepository {
  Future<ApkVersion?> getApkVersion(int categoryId);
} 