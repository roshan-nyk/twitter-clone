import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:roshan_twitter_clone/constants/appwrite_constants.dart';
import 'package:roshan_twitter_clone/core/core.dart';
import 'package:roshan_twitter_clone/core/providers.dart';
import 'package:roshan_twitter_clone/model/notification_model.dart';

final notificationApiProvider = Provider((ref) {
  final db = ref.watch(appWriteDatabaseProvider);
  // final realtime = ref.watch(appWriteRealtimeProvider);
  final client = ref.watch(appWriteClientProvider);
  final realtime = Realtime(client);
  return NotificationAPI(db: db, realtime: realtime);
});

abstract class INotificationAPI {
  FutureEitherVoid createNotification(NotificationModel notification);
  Future<List<Document>> getNotificationsForAUser(String uid);
  Stream<RealtimeMessage> getRealTimeNotification();
}

class NotificationAPI extends INotificationAPI {
  NotificationAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  final Databases _db;
  final Realtime _realtime;
  RealtimeSubscription? _notificationSubscription;


  @override
  FutureEitherVoid createNotification(NotificationModel notification) async {
    try {
      await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.notificationCollectionId,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      debugPrint(e.response.toString());
      return left(
        Failure(e.response.toString(), st),
      );
    } catch (e, st) {
      debugPrint(e.toString());
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getNotificationsForAUser(String uid) async {
    final document = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.notificationCollectionId,
      queries: [
        Query.equal('uid', uid) as String,
      ],
    );
    return document.documents;
  }

  @override
  Stream<RealtimeMessage> getRealTimeNotification() async* {
    try {
      _notificationSubscription = _realtime.subscribe([
        'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.notificationCollectionId}.documents',
      ]);

      await for (final data in _notificationSubscription!.stream) {
        final isUpdatedTweet = data.events.contains(
          'databases.*'
          '.collections.${AppWriteConstants.notificationCollectionId}'
          '.documents.*',
        );
        if (isUpdatedTweet) {
          yield data;
        }
      }
    } on AppwriteException catch (e, stackTrace) {
      debugPrint('Roshan Notification');
      debugPrint(e.response.toString());
    } on Exception catch (e, stackTrace) {
      debugPrint(e.toString());
    }
  }
}
