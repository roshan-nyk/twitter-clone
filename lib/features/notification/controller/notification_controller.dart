import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/apis/notification_api.dart';
import 'package:roshan_twitter_clone/core/enums/notification_type_enum.dart';
import 'package:roshan_twitter_clone/model/notification_model.dart';

final notificationControllerProvider = StateNotifierProvider<NotificationController, bool>((ref) {
  final notificationApi = ref.watch(notificationApiProvider);
  return NotificationController(notificationAPI: notificationApi);
});

final getNotificationsOfAUserProvider = FutureProvider.autoDispose.family((ref, String uid) async {
  final notificationController = ref.watch(notificationControllerProvider.notifier);
  return notificationController.getNotificationsForAUser(uid);
});

final getRealTimeNotificationsProvider = StreamProvider.autoDispose<RealtimeMessage>((ref) {
  final notificationApi = ref.watch(notificationApiProvider);
  return notificationApi.getRealTimeNotification();
});

class NotificationController extends StateNotifier<bool> {
  NotificationController({required this.notificationAPI}) : super(false);

  final NotificationAPI notificationAPI;

  Future<void> createNotification({
    required String text,
    required String uid,
    required String tweetId,
    required NotificationType notificationType,
  }) async {
    final notification = NotificationModel(
      text: text,
      id: '',
      tweetId: tweetId,
      uid: uid,
      notificationType: notificationType,
    );
    final res = await notificationAPI.createNotification(notification);
    res.fold((l) => null, (r) => null);
  }

  Future<List<NotificationModel>> getNotificationsForAUser(String uid) async {
    final documentList = await notificationAPI.getNotificationsForAUser(uid);
    return documentList.map((element) => NotificationModel.fromMap(element.data)).toList();
  }
}
