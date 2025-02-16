import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:roshan_twitter_clone/features/tweet/view/tweet_reply_view.dart';
import 'package:roshan_twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:roshan_twitter_clone/model/tweet_model.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/common_widgets.dart';

class HashtagView extends ConsumerWidget {
  const HashtagView({
    required this.hashTag,
    required this.copyTweetList,
    super.key,
  });
  static MaterialPageRoute<HashtagView> route({required String hashTag}) => MaterialPageRoute(
        builder: (context) => HashtagView(
          hashTag: hashTag,
          copyTweetList: [],
        ),
      );

  final String hashTag;
  final List<Tweet> copyTweetList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          hashTag,
          style: const TextStyle(fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: ref.watch(getTweetByHashtagProvider(hashTag)).when(
            data: (tweetList) {
              copyTweetList
                ..clear()
                ..addAll(tweetList);
              return ListView.builder(
                itemCount: copyTweetList.length,
                itemBuilder: (context, index) {
                  final currentTweet = copyTweetList[index];
                  return GestureDetector(
                    onTap: () {
                      debugPrint('onTap');
                      Navigator.of(context).push(
                        TwitterReplyScreen.route(currentTweet),
                      );
                    },
                    child: TweetCard(tweet: currentTweet),
                  );
                },
              );
            },
            error: (err, stack) => ErrorText(errorText: err.toString()),
            loading: () => copyTweetList.isEmpty
                ? const Loader()
                : ListView.builder(
                    itemCount: copyTweetList.length,
                    itemBuilder: (context, index) {
                      final currentTweet = copyTweetList[index];
                      return GestureDetector(
                        onTap: () {
                          debugPrint('onTap');
                          Navigator.of(context).push(
                            TwitterReplyScreen.route(currentTweet),
                          );
                        },
                        child: TweetCard(tweet: currentTweet),
                      );
                    },
                  ),
          ),
    );
  }
}
