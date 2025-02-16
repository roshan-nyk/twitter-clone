class AppWriteConstants {
  static const String databaseId = '';
  static const String projectId = '';
  static const String endPoint = '';

  static const String userCollectionId = '';
  static const String tweetsCollectionId = '';
  static const String notificationCollectionId = '';

  static const String imageBucketId = '';
  static String imageUrl(String imageId) => '/storage/buckets/$imageBucketId/files/$imageId/view?project=$projectId&mode=admin';
  // '$endPoint/storage/buckets/$imageBucketId/files/$imageId/view?project=$projectId&mode=admin';
}