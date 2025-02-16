import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roshan_twitter_clone/constants/appwrite_constants.dart';
import 'package:roshan_twitter_clone/constants/asset_constants.dart';
import 'package:roshan_twitter_clone/features/tweet/view/tweet_reply_view.dart';
import 'package:roshan_twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:roshan_twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:roshan_twitter_clone/features/user_profile/view/edit_profile_view.dart';
import 'package:roshan_twitter_clone/features/user_profile/widgets/follow_count.dart';
import 'package:roshan_twitter_clone/model/tweet_model.dart';
import 'package:roshan_twitter_clone/model/user_model.dart';
import 'package:roshan_twitter_clone/theme/pallete.dart';

class NestedScrollViewWidget extends ConsumerWidget {
  const NestedScrollViewWidget({
    required this.tweetList,
    required this.currentUser,
    required this.loggedInUser,
    super.key,
  });

  final List<Tweet> tweetList;
  final UserModel currentUser;
  final UserModel loggedInUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('called in: nested_scroll_view.dart');
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 150,
            floating: true,
            snap: true,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: currentUser.bannerPic.isEmpty
                      ? Container(
                          color: Pallete.blueColor,
                        )
                      : Image.network(
                          AppWriteConstants.endPoint + currentUser.bannerPic,
                          fit: BoxFit.fitWidth,
                        ),
                ),
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      AppWriteConstants.endPoint + currentUser.profilePic,
                    ),
                    radius: 35,
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: OutlinedButton(
                    onPressed: () {
                      if (loggedInUser.uid == currentUser.uid) {
                        Navigator.of(context).push(EditProfileView.route());
                      } else {
                        ref.read(userProfileControllerProvider.notifier).updateFollowersData(
                              loggedInUser: loggedInUser,
                              selectedUser: currentUser,
                              context: context,
                            );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Pallete.whiteColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                    ),
                    child: Text(
                      loggedInUser.uid == currentUser.uid
                          ? 'Edit Profile'
                          : loggedInUser.following.contains(currentUser.uid)
                              ? 'Unfollow'
                              : 'Follow',
                      style: const TextStyle(
                        color: Pallete.backgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    children: [
                      Text(
                        currentUser.name,
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      if (currentUser.isTwitterBlue)
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: SvgPicture.asset(AssetsConstants.verifiedIcon),
                        ),
                    ],
                  ),
                  Text(
                    '@${currentUser.name}',
                    style: const TextStyle(
                      fontSize: 17,
                      color: Pallete.greyColor,
                    ),
                  ),
                  Text(
                    currentUser.bio,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Pallete.greyColor,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      FollowCount(
                        text: 'Following',
                        count: currentUser.following.length,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      FollowCount(
                        text: 'Followers',
                        count: currentUser.followers.length,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Divider(
                    color: Pallete.greyColor,
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: ListView.builder(
        itemCount: tweetList.length,
        itemBuilder: (context, index) {
          final currentTweet = tweetList[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                TwitterReplyScreen.route(currentTweet),
              );
            },
            child: TweetCard(tweet: currentTweet),
          );
        },
      ),
    );
  }
}
