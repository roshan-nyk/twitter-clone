import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/features/user_profile/widgets/user_profile.dart';
import 'package:roshan_twitter_clone/model/user_model.dart';

class UserProfileView extends ConsumerWidget {
  const UserProfileView({
    required this.userModel,
    super.key,
  });

  static MaterialPageRoute<UserProfileView> route(UserModel userModel) => MaterialPageRoute(builder: (context) => UserProfileView(userModel: userModel));

  final UserModel userModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copyModel = userModel;
    return Scaffold(
      body: UserProfile(
        user: copyModel,
        copyTweetList: [],
      ),
    );
  }
}
