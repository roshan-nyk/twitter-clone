import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:roshan_twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:roshan_twitter_clone/model/tweet_model.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/common_widgets.dart';

class TwitterReplyScreen extends ConsumerWidget {
  const TwitterReplyScreen({
    required Tweet tweet,
    required this.copyTweetList,
    super.key,
  }) : _tweet = tweet;

  final List<Tweet> copyTweetList;

  static MaterialPageRoute<TwitterReplyScreen> route(Tweet tweet) => MaterialPageRoute(
        builder: (context) => TwitterReplyScreen(
          tweet: tweet,
          copyTweetList: [],
        ),
      );

  final Tweet _tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
      ),
      body: Column(
        children: [
          TweetCard(
            tweet: _tweet,
          ),
          ref.watch(getRepliesToTweetProvider(_tweet)).when(
                data: (tweetList) {
                  copyTweetList
                    ..clear()
                    ..addAll(tweetList);
                  return Expanded(
                    child: ListView.builder(
                      itemCount: copyTweetList.length,
                      itemBuilder: (context, index) {
                        final currentTweet = copyTweetList[index];
                        return TweetCard(tweet: currentTweet);
                      },
                    ),
                  );
                },
                error: (error, stackTrace) {
                  debugPrint(stackTrace.toString());
                  return Expanded(
                      child: ErrorText(
                    errorText: error.toString(),
                  ));
                },
                loading: () => copyTweetList.isEmpty
                    ? const Expanded(child: Loader())
                    : Expanded(
                        child: ListView.builder(
                          itemCount: copyTweetList.length,
                          itemBuilder: (context, index) {
                            final currentTweet = copyTweetList[index];
                            return TweetCard(tweet: currentTweet);
                          },
                        ),
                      ),
              ),
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (replyTweet) {
          final res = ref.read(tweetControllerProvider.notifier).createNewTweet(
            images: [],
            text: replyTweet,
            context: context,
            repliedToTheTweetId: _tweet.id,
            repliedToTheUserId: _tweet.uid,
          );
        },
        decoration: const InputDecoration(
          hintText: ' Tweet your reply',
        ),
      ),
    );
  }
}
