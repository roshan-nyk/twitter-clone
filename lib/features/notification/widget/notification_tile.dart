import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roshan_twitter_clone/constants/asset_constants.dart';
import 'package:roshan_twitter_clone/core/enums/notification_type_enum.dart';
import 'package:roshan_twitter_clone/model/notification_model.dart';
import 'package:roshan_twitter_clone/theme/pallete.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  const NotificationTile({
    required this.notification,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
              Icons.person,
              color: Pallete.blueColor,
            )
          : notification.notificationType == NotificationType.like
              ? SvgPicture.asset(
                  AssetsConstants.likeFilledIcon,
                  color: Pallete.redColor,
                  height: 20,
                )
              : notification.notificationType == NotificationType.retweet
                  ? SvgPicture.asset(
                      AssetsConstants.retweetIcon,
                      color: Pallete.whiteColor,
                      height: 20,
                    )
                  : null,
      title: Text(notification.text),
    );
  }
}
