import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/apis/storage_api.dart';
import 'package:roshan_twitter_clone/apis/tweet_api.dart';
import 'package:roshan_twitter_clone/core/enums/notification_type_enum.dart';
import 'package:roshan_twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:roshan_twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:roshan_twitter_clone/features/notification/controller/notification_controller.dart';
import 'package:roshan_twitter_clone/model/tweet_model.dart';
import 'package:roshan_twitter_clone/model/user_model.dart';
import 'package:roshan_twitter_clone/utils/common_functions.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  final storageAPI = ref.watch(storageAPIProvider);
  final notificationController = ref.watch(notificationControllerProvider.notifier);
  return TweetController(
    ref: ref,
    tweetAPI: tweetAPI,
    storageAPI: storageAPI,
    notificationController: notificationController,
  );
});

final getTweetsProvider = FutureProvider.autoDispose((ref) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  ref.watch(getRealTimeNewTweetsProvider);
  return tweetController.getTweets();
});

final getRepliesToTweetProvider = FutureProvider.autoDispose.family((ref, Tweet tweet) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  ref.watch(getRealTimeNewTweetsProvider);
  return tweetController.getRepliesToTweet(tweet);
});

final getRealTimeNewTweetsProvider = StreamProvider.autoDispose((ref) {
  final tweetApi = ref.watch(tweetAPIProvider);
  return tweetApi.getRealTimeNewTweets();
});

final getRealTimeUpdatedTweetsProvider = StreamProvider.autoDispose((ref) {
  final tweetApi = ref.watch(tweetAPIProvider);
  return tweetApi.getRealTimeUpdatedTweets();
});

final getOwnerOfTheTweetProvider = FutureProvider.autoDispose.family((ref, String tweetId) async {
  return ref.watch(getTweetByIdProvider(tweetId)).whenData((originalTweet) {
    return ref.watch(getUserDetailsByUserIdProvider(originalTweet.uid)).whenData((ownerOfTweeter) => ownerOfTweeter).value;
  }).value;
});

final getTweetByIdProvider = FutureProvider.autoDispose.family((ref, String tweetId) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  final originalTweet = await tweetController.getTweetById(tweetId);
  return originalTweet;
});

final getTweetByHashtagProvider = FutureProvider.autoDispose.family((ref, String hashTag) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  final originalTweet = await tweetController.getTweetByHashTag(hashTag);
  ref
    ..watch(getRealTimeNewTweetsProvider)
    ..watch(getRealTimeUpdatedTweetsProvider);
  return originalTweet;
});

class TweetController extends StateNotifier<bool> {
  TweetController({
    required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required NotificationController notificationController,
  })  : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _notificationController = notificationController,
        super(false);

  final Ref _ref;
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final NotificationController _notificationController;

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((element) => Tweet.fromMap(element.data)).toList();
  }

  void createNewTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedToTheTweetId, // The id of tweet to which we are replying
    required String repliedToTheUserId, // The id of Owner/User of the tweet to which we are replying
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text');
      return;
    }
    if (images.isNotEmpty) {
      _createImageTweet(
        images: images,
        text: text,
        context: context,
        repliedToTheTweetId: repliedToTheTweetId,
        repliedToTheUserId: repliedToTheUserId,
      );
    } else {
      _createTextTweet(
        text: text,
        context: context,
        repliedToTweetId: repliedToTheTweetId,
        repliedToUserId: repliedToTheUserId,
      );
    }
  }

  Future<void> _createImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedToTheTweetId,
    required String repliedToTheUserId,
  }) async {
    state = true;
    final hashTags = _getHashTagsFromText(text);
    final link = _getLinkFromText(text);
    final imagesLinks = await _storageAPI.uploadImages(images);
    final user = _ref.read(loggedInUserDetailsProvider).value!;
    final tweet = Tweet(
      text: text,
      hashTags: hashTags,
      link: link,
      imageLinks: imagesLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reTweetCount: 0,
      reTweetedBy: '',
      repliedTo: repliedToTheTweetId,
    );
    final result = await _tweetAPI.createNewTweet(tweet);
    result.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToTheUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: '${user.name} replied to your tweet',
          uid: repliedToTheUserId,
          tweetId: r.$id,
          notificationType: NotificationType.reply,
        );
      }
      Navigator.pop(context);
    });
    state = false;
  }

  Future<void> _createTextTweet({
    required String text,
    required BuildContext context,
    required String repliedToTweetId,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashTags = _getHashTagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(loggedInUserDetailsProvider).value!;
    debugPrint(hashTags.toString());
    final tweet = Tweet(
      text: text,
      hashTags: hashTags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reTweetCount: 0,
      reTweetedBy: '',
      repliedTo: repliedToTweetId,
    );
    final result = await _tweetAPI.createNewTweet(tweet);
    result.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: '${user.name} replied to your tweet',
          uid: repliedToUserId,
          tweetId: r.$id,
          notificationType: NotificationType.reply,
        );
      }
      Navigator.pop(context);
    });
    state = false;
  }

  String _getLinkFromText(String text) {
    var link = '';
    final wordsInSentence = text.split(' ');
    for (final word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
        break;
      }
    }
    return link;
  }

  List<String> _getHashTagsFromText(String text) {
    final hashTags = <String>[];
    final wordsInSentence = text.split(' ');
    for (final word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashTags.add(word);
      }
    }
    return hashTags;
  }

  Future<void> likeTweet(Tweet tweet, UserModel userModel) async {
    final likes = tweet.likes;
    var isLiked = false;
    if (likes.contains(userModel.uid)) {
      likes.remove(userModel.uid);
    } else {
      likes.add(userModel.uid);
      isLiked = true;
    }

    final updatedTweet = tweet.copyWith(
      likes: likes,
    );

    final res = await _tweetAPI.likeTweet(updatedTweet);
    res.fold((l) => null, (r) {
      if (isLiked) {
        _notificationController.createNotification(
          text: '${userModel.name} liked your tweet',
          uid: tweet.uid,
          tweetId: tweet.id,
          notificationType: NotificationType.like,
        );
      }
    });
  }

  Future<void> reTweet(
    Tweet tweet,
    UserModel userModel,
    BuildContext context,
  ) async {
    var updatedTweet = tweet.copyWith(
      reTweetCount: tweet.reTweetCount + 1,
    );

    final result1 = await _tweetAPI.updateReTweetCount(updatedTweet);
    result1.fold((l) {
      debugPrint(l.stacktrace.toString());
      return showSnackBar(context, l.toString());
    }, (r) async {
      updatedTweet = tweet.copyWith(
        id: ID.unique(),
        reTweetCount: 0,
        likes: [],
        commentIds: [],
        tweetedAt: DateTime.now(),
        reTweetedBy: userModel.uid,
      );

      final result2 = await _tweetAPI.createNewTweet(updatedTweet);
      result2.fold(
        (l) {
          debugPrint(l.stacktrace.toString());
          return showSnackBar(context, l.toString());
        },
        (r) {
          _notificationController.createNotification(
            text: '${userModel.name} shared your tweet',
            uid: tweet.uid,
            tweetId: tweet.id,
            notificationType: NotificationType.retweet,
          );
          showSnackBar(context, 'Retweeted');
        },
      );
    });
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet) async {
    final documents = await _tweetAPI.getRepliesToTweet(tweet);
    return documents.map((element) => Tweet.fromMap(element.data)).toList();
  }

  Future<Tweet> getTweetById(String tweetId) async {
    final document = await _tweetAPI.getTweetById(tweetId);
    return Tweet.fromMap(document.data);
  }

  Future<List<Tweet>> getTweetByHashTag(String hashTag) async {
    final documents = await _tweetAPI.getTweetsByHashtag(hashTag);
    return documents.map((element) => Tweet.fromMap(element.data)).toList();
  }
}
