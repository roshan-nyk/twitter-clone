import 'package:flutter/foundation.dart';
import 'package:roshan_twitter_clone/core/enums/notification_type_enum.dart';

@immutable
class NotificationModel {
//<editor-fold desc="Data Methods">
  const NotificationModel({
    required this.text,
    required this.id,
    required this.tweetId,
    // In this case both tweetId and uid doesn't need to point to the same tweet all the time
    // ex:- as in case of replying to a tweet we are storing new tweetId
    // but uid of the user to whose tweet we are replying to
    // bcz this uid user will get notification about the reply
    // in other cases they point to the same tweet [like, share...]
    required this.uid,
    required this.notificationType,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      text: map['text'] as String,
      id: map[r'$id'] as String,
      tweetId: map['tweetId'] as String,
      uid: map['uid'] as String,
      notificationType: (map['notificationType'] as String).toNotificationTypeEnum(),
    );
  }
  final String text;
  final String id;
  final String tweetId;
  final String uid;
  final NotificationType notificationType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationModel &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          id == other.id &&
          tweetId == other.tweetId &&
          uid == other.uid &&
          notificationType == other.notificationType);

  @override
  int get hashCode => text.hashCode ^ id.hashCode ^ tweetId.hashCode ^ uid.hashCode ^ notificationType.hashCode;

  @override
  String toString() {
    return 'Notification{ text: $text, id: $id, tweetId: $tweetId, uid: $uid, notificationType: $notificationType,}';
  }

  NotificationModel copyWith({
    String? text,
    String? id,
    String? tweetId,
    String? uid,
    NotificationType? notificationType,
  }) {
    return NotificationModel(
      text: text ?? this.text,
      id: id ?? this.id,
      tweetId: tweetId ?? this.tweetId,
      uid: uid ?? this.uid,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      // 'id': id,
      'tweetId': tweetId,
      'uid': uid,
      'notificationType': notificationType.type,
    };
  }

//</editor-fold>
}
