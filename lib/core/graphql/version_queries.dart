class VersionQueries {
  static String getApkVersion = '''
    query ApkVersion(\$categoryId: Int!) {
      apkVersion(categoryId: \$categoryId) {
        updatedAt
        version
        id
        category {
          id
          name
          order
          icon
          description
          createdAt
          deleteDate
        }
      }
    }
  ''';
} 