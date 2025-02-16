import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/constants/appwrite_constants.dart';
import 'package:roshan_twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:roshan_twitter_clone/features/notification/controller/notification_controller.dart';
import 'package:roshan_twitter_clone/features/notification/widget/notification_tile.dart';
import 'package:roshan_twitter_clone/model/notification_model.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/common_widgets.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('called in: notification_view.dart');
    final loggedInUser = ref.watch(loggedInUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: loggedInUser == null
          ? const Loader()
          : ref.watch(getNotificationsOfAUserProvider(loggedInUser.uid)).when(
                data: (notificationList) {
                  return ref.watch(getRealTimeNotificationsProvider).when(
                        data: (data) {
                          final isNewTweet = data.events.contains('databases.*'
                              '.collections.${AppWriteConstants.notificationCollectionId}'
                              '.documents.*.create');
                          if (isNewTweet) {
                            final newOrUpdatedNotification = NotificationModel.fromMap(data.payload);
                            if (newOrUpdatedNotification.uid == loggedInUser.uid) {
                              notificationList.insert(0, newOrUpdatedNotification);
                            }
                          }
                          return ListView.builder(
                            itemCount: notificationList.length,
                            itemBuilder: (context, index) {
                              final currentNotification = notificationList[index];
                              return NotificationTile(
                                notification: currentNotification,
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) {
                          debugPrint(stackTrace.toString());
                          return ErrorText(
                            errorText: error.toString(),
                          );
                        },
                        loading: () => ListView.builder(
                          itemCount: notificationList.length,
                          itemBuilder: (context, index) {
                            final currentNotification = notificationList[index];
                            return NotificationTile(
                              notification: currentNotification,
                            );
                          },
                        ),
                      );
                },
                error: (error, stackTrace) {
                  debugPrint(stackTrace.toString());
                  return ErrorText(
                    errorText: error.toString(),
                  );
                },
                loading: Loader.new,
              ),
    );
  }
}
