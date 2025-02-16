import 'package:flutter/foundation.dart';
import 'package:roshan_twitter_clone/core/enums/tweet_type_enum.dart';

@immutable
class Tweet {
//<editor-fold desc="Data Methods">
  const Tweet({
    required this.text,
    required this.hashTags,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.tweetType,
    required this.tweetedAt,
    required this.likes,
    required this.commentIds,
    required this.id,
    required this.reTweetCount,
    required this.reTweetedBy, // userId
    required this.repliedTo, // tweetId
  });

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text: map['text'] as String,
      hashTags: List<String>.from(map['hashTags'] as Iterable), // map['hashTags'] as List<String>,
      link: map['link'] as String,
      imageLinks: List<String>.from(map['imageLinks'] as Iterable), // map['imageLinks'] as List<String>,
      uid: map['uid'] as String,
      tweetType: (map['tweetType'] as String).toTweetTypeEnum(),
      tweetedAt: DateTime.fromMillisecondsSinceEpoch(map['tweetedAt'] as int),
      likes: List<String>.from(map['likes'] as Iterable), // map['likes'] as List<String>,
      commentIds: List<String>.from(map['commentIds'] as Iterable), // map['commentIds'] as List<String>,
      id: map[r'$id'] as String,
      reTweetCount: map['reTweetCount'] as int,
      reTweetedBy: map['reTweetedBy'] as String,
      repliedTo: map['repliedTo'] as String,
    );
  }

  final String text;
  final List<String> hashTags;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final TweetType tweetType;
  final DateTime tweetedAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id;
  final int reTweetCount;
  final String reTweetedBy;
  final String repliedTo;

  Tweet copyWith({
    String? text,
    List<String>? hashTags,
    String? link,
    List<String>? imageLinks,
    String? uid,
    TweetType? tweetType,
    DateTime? tweetedAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
    int? reTweetCount,
    String? reTweetedBy,
    String? repliedTo,
  }) {
    return Tweet(
      text: text ?? this.text,
      hashTags: hashTags ?? this.hashTags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      tweetType: tweetType ?? this.tweetType,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      reTweetCount: reTweetCount ?? this.reTweetCount,
      reTweetedBy: reTweetedBy ?? this.reTweetedBy,
      repliedTo: repliedTo ?? this.repliedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'hashTags': hashTags,
      'link': link,
      'imageLinks': imageLinks,
      'uid': uid,
      'tweetType': tweetType.type,
      'tweetedAt': tweetedAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      // 'id': id, //Appwrite will provide this for us
      'reTweetCount': reTweetCount,
      'reTweetedBy': reTweetedBy,
      'repliedTo': repliedTo,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tweet &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          hashTags == other.hashTags &&
          link == other.link &&
          imageLinks == other.imageLinks &&
          uid == other.uid &&
          tweetType == other.tweetType &&
          tweetedAt == other.tweetedAt &&
          likes == other.likes &&
          commentIds == other.commentIds &&
          id == other.id &&
          reTweetCount == other.reTweetCount &&
          reTweetedBy == other.reTweetedBy &&
          repliedTo == other.repliedTo);

  @override
  int get hashCode =>
      text.hashCode ^
      hashTags.hashCode ^
      link.hashCode ^
      imageLinks.hashCode ^
      uid.hashCode ^
      tweetType.hashCode ^
      tweetedAt.hashCode ^
      likes.hashCode ^
      commentIds.hashCode ^
      id.hashCode ^
      reTweetCount.hashCode ^
      reTweetedBy.hashCode ^
      repliedTo.hashCode;

  @override
  String toString() {
    return 'Tweet{ text: $text, hashTags: $hashTags, link: $link, '
        'imageLinks: $imageLinks, uid: $uid, tweetType: $tweetType, '
        'tweetedAt: $tweetedAt, likes: $likes, commentIds: $commentIds, id: $id,'
        ' reTweetCount: $reTweetCount, reTweetedBy : $reTweetedBy, repliedTo : $repliedTo,}';
  }

//</editor-fold>
}
