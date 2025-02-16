import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:roshan_twitter_clone/constants/appwrite_constants.dart';
import 'package:roshan_twitter_clone/constants/asset_constants.dart';
import 'package:roshan_twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:roshan_twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:roshan_twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:roshan_twitter_clone/features/tweet/widgets/carousel_image.dart';
import 'package:roshan_twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:roshan_twitter_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:roshan_twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:roshan_twitter_clone/model/tweet_model.dart';
import 'package:roshan_twitter_clone/theme/pallete.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/common_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends ConsumerWidget {
  const TweetCard({
    required Tweet tweet,
    super.key,
  }) : _tweet = tweet;

  final Tweet _tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var copyTweet = _tweet;
    debugPrint('called in: tweet_card.dart');
    final loggedInUser = ref.watch(loggedInUserDetailsProvider).value;
    return loggedInUser == null
        ? const SizedBox.shrink()
        : ref.watch(getUserDetailsByUserIdProvider(copyTweet.uid)).when(
              data: (currentTweetOwner) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(UserProfileView.route(currentTweetOwner));
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                AppWriteConstants.endPoint + currentTweetOwner.profilePic,
                              ),
                              radius: 35,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (copyTweet.reTweetedBy.isNotEmpty)
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AssetsConstants.retweetIcon,
                                      color: Pallete.greyColor,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    ref
                                        .watch(
                                          getUserDetailsByUserIdProvider(copyTweet.reTweetedBy),
                                        )
                                        .when(
                                          data: (user) {
                                            return Text(
                                              '${user.name} retweeted',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Pallete.greyColor,
                                              ),
                                            );
                                          },
                                          error: (error, st) => ErrorText(errorText: error.toString()),
                                          loading: SizedBox.shrink,
                                        ),
                                  ],
                                ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: currentTweetOwner.isTwitterBlue ? 1 : 5,
                                    ),
                                    child: Text(
                                      currentTweetOwner.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (currentTweetOwner.isTwitterBlue)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5.0),
                                      child: SvgPicture.asset(AssetsConstants.verifiedIcon),
                                    ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        right: 5,
                                      ),
                                      child: Text(
                                        '@${currentTweetOwner.name}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Pallete.greyColor,
                                          fontSize: 17,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      right: 5,
                                    ),
                                    child: Text(
                                      timeago.format(
                                        copyTweet.tweetedAt,
                                        locale: 'en', //'en-short'
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Pallete.greyColor,
                                        fontSize: 17,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              if (copyTweet.repliedTo.isNotEmpty)
                                ref
                                    .watch(
                                      getOwnerOfTheTweetProvider(
                                        copyTweet.repliedTo,
                                      ),
                                    )
                                    .when(
                                      data: (ownerOfTheTweet) {
                                        return RichText(
                                          text: TextSpan(
                                            text: 'Replying to ',
                                            style: const TextStyle(
                                              color: Pallete.greyColor,
                                              fontSize: 16,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '@${ownerOfTheTweet?.name}',
                                                style: const TextStyle(
                                                  color: Pallete.greyColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      error: (error, stackTrace) {
                                        debugPrint(stackTrace.toString());
                                        return ErrorText(
                                          errorText: error.toString(),
                                        );
                                      },
                                      loading: SizedBox.shrink,
                                    ),
                              Row(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Center(
                                                    child: HashTagText(
                                                      text: copyTweet.text,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (copyTweet.tweetType == TweetType.image) CarouselImage(imageLinks: copyTweet.imageLinks),
                              if (copyTweet.link.isNotEmpty) ...[
                                const SizedBox(
                                  height: 4,
                                ),
                                AnyLinkPreview(
                                  link: 'https://${copyTweet.link}',
                                  displayDirection: UIDirection.uiDirectionHorizontal,
                                ),
                              ],
                              ref.watch(getRealTimeUpdatedTweetsProvider).when(
                                    data: (data) {
                                      final receivedTweet = Tweet.fromMap(data.payload);
                                      if (receivedTweet.id == copyTweet.id) {
                                        copyTweet = receivedTweet;
                                      }
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          top: 10,
                                          right: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TweetIconButton(
                                              pathName: AssetsConstants.viewsIcon,
                                              text: (copyTweet.commentIds.length + copyTweet.reTweetCount + copyTweet.likes.length).toString(),
                                              onTap: () {},
                                            ),
                                            TweetIconButton(
                                              pathName: AssetsConstants.commentIcon,
                                              text: copyTweet.commentIds.length.toString(),
                                              onTap: () {},
                                            ),
                                            TweetIconButton(
                                              pathName: AssetsConstants.retweetIcon,
                                              text: copyTweet.reTweetCount.toString(),
                                              onTap: () {
                                                ref.read(tweetControllerProvider.notifier).reTweet(
                                                      copyTweet,
                                                      loggedInUser,
                                                      context,
                                                    );
                                              },
                                            ),
                                            LikeButton(
                                              size: 25,
                                              onTap: (isLiked) async {
                                                await ref.read(tweetControllerProvider.notifier).likeTweet(copyTweet, loggedInUser);
                                                return !isLiked;
                                              },
                                              isLiked: copyTweet.likes.contains(loggedInUser.uid),
                                              likeBuilder: (isLiked) {
                                                return isLiked
                                                    ? SvgPicture.asset(
                                                        AssetsConstants.likeFilledIcon,
                                                        color: Pallete.redColor,
                                                        // color: Colors.greenAccent,
                                                      )
                                                    : SvgPicture.asset(
                                                        AssetsConstants.likeOutlinedIcon,
                                                        color: Pallete.greyColor,
                                                      );
                                              },
                                              likeCount: copyTweet.likes.length,
                                              countBuilder: (likeCount, isLiked, text) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(
                                                    left: 2,
                                                  ),
                                                  child: Text(
                                                    text,
                                                    style: TextStyle(
                                                      color: isLiked ? Pallete.redColor : Pallete.greyColor,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            TweetIconButton(
                                              pathName: '',
                                              text: '',
                                              onTap: () {},
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    error: (error, st) => ErrorText(errorText: error.toString()),
                                    loading: () => Container(
                                      margin: const EdgeInsets.only(
                                        top: 10,
                                        right: 20,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TweetIconButton(
                                            pathName: AssetsConstants.viewsIcon,
                                            text: (copyTweet.commentIds.length + copyTweet.reTweetCount + copyTweet.likes.length).toString(),
                                            onTap: () {},
                                          ),
                                          TweetIconButton(
                                            pathName: AssetsConstants.commentIcon,
                                            text: copyTweet.commentIds.length.toString(),
                                            onTap: () {},
                                          ),
                                          TweetIconButton(
                                            pathName: AssetsConstants.retweetIcon,
                                            text: copyTweet.reTweetCount.toString(),
                                            onTap: () {
                                              ref.read(tweetControllerProvider.notifier).reTweet(
                                                    copyTweet,
                                                    loggedInUser,
                                                    context,
                                                  );
                                            },
                                          ),
                                          LikeButton(
                                            size: 25,
                                            onTap: (isLiked) async {
                                              await ref.read(tweetControllerProvider.notifier).likeTweet(copyTweet, loggedInUser);
                                              return !isLiked;
                                            },
                                            isLiked: copyTweet.likes.contains(loggedInUser.uid),
                                            likeBuilder: (isLiked) {
                                              return isLiked
                                                  ? SvgPicture.asset(
                                                      AssetsConstants.likeFilledIcon,
                                                      color: Pallete.redColor,
                                                      // color: Colors.greenAccent,
                                                    )
                                                  : SvgPicture.asset(
                                                      AssetsConstants.likeOutlinedIcon,
                                                      color: Pallete.greyColor,
                                                    );
                                            },
                                            likeCount: copyTweet.likes.length,
                                            countBuilder: (likeCount, isLiked, text) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 2,
                                                ),
                                                child: Text(
                                                  text,
                                                  style: TextStyle(
                                                    color: isLiked ? Pallete.redColor : Pallete.greyColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          TweetIconButton(
                                            pathName: '',
                                            text: '',
                                            onTap: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              const SizedBox(
                                height: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Pallete.greyColor,
                    ),
                  ],
                );
              },
              error: (error, stackTrace) {
                debugPrint(stackTrace.toString());
                return ErrorText(errorText: error.toString());
              },
              loading: SizedBox.shrink, //const Loader(),
            );
  }
}
