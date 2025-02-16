import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:roshan_twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:roshan_twitter_clone/features/user_profile/widgets/nested_scroll_view.dart';
import 'package:roshan_twitter_clone/model/tweet_model.dart';
import 'package:roshan_twitter_clone/model/user_model.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/common_widgets.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({
    required this.user,
    required this.copyTweetList,
    super.key,
  });

  final UserModel user;
  final List<Tweet> copyTweetList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Needed to check wheteher the selected is a normal user or owner of this account
    debugPrint('called in: user_profile.dart');

    final loggedInUser = ref.watch(loggedInUserDetailsProvider).value;

    var copyUserModel = user;

    if (loggedInUser != null && loggedInUser.uid == user.uid) {
      copyUserModel = loggedInUser;
    }

    return loggedInUser == null
        ? const Loader()
        : ref.watch(getTweetsByUserProvider(copyUserModel.uid)).when(
              data: (tweetList) {
                copyTweetList
                  ..clear()
                  ..addAll(tweetList);
                return NestedScrollViewWidget(
                  tweetList: copyTweetList,
                  currentUser: copyUserModel,
                  loggedInUser: loggedInUser,
                );
              },
              error: (er, st) => ErrorText(errorText: er.toString()),
              loading: () => copyTweetList.isEmpty
                  ? const Loader()
                  : NestedScrollViewWidget(
                      tweetList: copyTweetList,
                      currentUser: copyUserModel,
                      loggedInUser: loggedInUser,
                    ),
            );
  }
}
