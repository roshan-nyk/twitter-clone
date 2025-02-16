import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:roshan_twitter_clone/features/tweet/view/tweet_reply_view.dart';
import 'package:roshan_twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:roshan_twitter_clone/model/tweet_model.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/common_widgets.dart';

class TweetList extends ConsumerWidget {
  const TweetList({
    required this.copyTweetList,
    super.key,
  });

  final List<Tweet> copyTweetList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
          data: (tweetList) {
            copyTweetList
              ..clear()
              ..addAll(tweetList);

            debugPrint('called in: tweet_list.dart:- ${tweetList.length}');

            return ListView.builder(
              itemCount: copyTweetList.length,
              itemBuilder: (context, index) {
                final currentTweet = copyTweetList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      TwitterReplyScreen.route(currentTweet),
                    );
                  },
                  child: TweetCard(tweet: currentTweet),
                );
              },
            );
          },
          error: (error, stackTrace) {
            debugPrint(stackTrace.toString());
            return ErrorText(errorText: error.toString());
          },
          loading: () => copyTweetList.isEmpty
              ? const Loader()
              : ListView.builder(
                  itemCount: copyTweetList.length,
                  itemBuilder: (context, index) {
                    final currentTweet = copyTweetList[index];
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
