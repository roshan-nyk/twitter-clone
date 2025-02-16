import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/apis/storage_api.dart';
import 'package:roshan_twitter_clone/apis/tweet_api.dart';
import 'package:roshan_twitter_clone/apis/user_api.dart';
import 'package:roshan_twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:roshan_twitter_clone/model/tweet_model.dart';
import 'package:roshan_twitter_clone/model/user_model.dart';
import 'package:roshan_twitter_clone/utils/common_functions.dart';

final userProfileControllerProvider = StateNotifierProvider<UserProfileController, bool>((ref) {
  final tweetApi = ref.watch(tweetAPIProvider);
  final storageApi = ref.watch(storageAPIProvider);
  final userApi = ref.watch(userApiProvider);
  return UserProfileController(
    tweetAPI: tweetApi,
    userApi: userApi,
    storageAPI: storageApi,
  );
});

final getTweetsByUserProvider = FutureProvider.autoDispose.family((ref, String uid) async {
  final userControllerProvider = ref.watch(userProfileControllerProvider.notifier);
  ref.watch(getRealTimeNewTweetsProvider);
  return userControllerProvider.getTweetsByUser(uid);
});

final getRealTimeUserProfileDataProvider = StreamProvider.autoDispose.family((ref, String uid) {
  final userApi = ref.watch(userApiProvider);
  return userApi.getRealTimeUserProfileData(uid);
});

class UserProfileController extends StateNotifier<bool> {
  UserProfileController({required TweetAPI tweetAPI, required UserApi userApi, required StorageAPI storageAPI})
      : _tweetAPI = tweetAPI,
        _userApi = userApi,
        _storageAPI = storageAPI,
        super(false);
  final TweetAPI _tweetAPI;
  final UserApi _userApi;
  final StorageAPI _storageAPI;

  Future<List<Tweet>> getTweetsByUser(String uid) async {
    final documents = await _tweetAPI.getTweetsByUser(uid);
    return documents.map((element) => Tweet.fromMap(element.data)).toList();
  }

  Future<void> updateUserProfile({
    required UserModel userModel,
    required File? bannerFile,
    required File? profileFile,
    required BuildContext context,
  }) async {
    state = true;
    var copyModel = userModel;
    if (bannerFile != null) {
      final bannerString = await _storageAPI.uploadImages([bannerFile]);
      copyModel = copyModel.copyWith(bannerPic: bannerString[0]);
    }
    if (profileFile != null) {
      final profileString = await _storageAPI.uploadImages([profileFile]);
      copyModel = copyModel.copyWith(profilePic: profileString[0]);
    }
    final res = await _userApi.updateUserData(copyModel);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => Navigator.of(context).pop());
  }

  Future<void> updateFollowersData({
    required UserModel loggedInUser,
    required UserModel selectedUser,
    required BuildContext context,
  }) async {
    final selectedUserId = selectedUser.uid;
    final loggedInUserId = loggedInUser.uid;
    final copySelectedUser = selectedUser.copyWith();
    final copyLoggedInUser = loggedInUser.copyWith();
    if (copyLoggedInUser.following.contains(selectedUserId)) {
      copyLoggedInUser.following.remove(selectedUserId);
      copySelectedUser.followers.remove(loggedInUserId);
    } else {
      copyLoggedInUser.following.add(selectedUserId);
      copySelectedUser.followers.add(loggedInUserId);
    }
    final res1 = await _userApi.updateUserData(copySelectedUser);
    res1.fold((l) => showSnackBar(context, l.message), (r) async {
      final res2 = await _userApi.updateUserData(copyLoggedInUser);
      res2.fold((l) => showSnackBar(context, l.message), (r) => null);
    });
  }
}
