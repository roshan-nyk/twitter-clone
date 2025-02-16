import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/apis/user_api.dart';
import 'package:roshan_twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:roshan_twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:roshan_twitter_clone/model/user_model.dart';

final exploreControllerProvider = StateNotifierProvider<ExploreController, bool>((ref) {
  final userApi = ref.watch(userApiProvider);
  return ExploreController(userApi: userApi);
});

final searchUserProvider = FutureProvider.autoDispose.family((ref, String searchValue) async {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  ref
    ..watch(getRealTimeNewTweetsProvider)
    ..watch(getRealTimeUpdatedTweetsProvider);
  final res = exploreController.getUsersForSearchedValue(searchValue);
  unawaited(
    res.then((value) {
      final listOfUsers = value;
      for (final user in listOfUsers) {
        ref.watch(getRealTimeUserProfileDataProvider(user.uid));
      }
    }),
  );
  return res;
});

class ExploreController extends StateNotifier<bool> {
  ExploreController({required UserApi userApi})
      : _userApi = userApi,
        super(false);

  final UserApi _userApi;

  Future<List<UserModel>> getUsersForSearchedValue(String searchValue) async {
    final documentList = await _userApi.getUsersForSearchValue(searchValue);
    return documentList.map((element) => UserModel.fromMap(element.data)).toList();
  }
}
