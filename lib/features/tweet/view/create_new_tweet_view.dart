import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roshan_twitter_clone/constants/constants.dart';
import 'package:roshan_twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:roshan_twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:roshan_twitter_clone/theme/pallete.dart';
import 'package:roshan_twitter_clone/utils/common_functions.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/common_widgets.dart';

class CreteNewTweetScreen extends ConsumerStatefulWidget {
  const CreteNewTweetScreen({
    super.key,
  });

  static MaterialPageRoute<CreteNewTweetScreen> route() => MaterialPageRoute(builder: (context) => const CreteNewTweetScreen());

  @override
  ConsumerState createState() => _CreteNewTweetScreenState();
}

class _CreteNewTweetScreenState extends ConsumerState<CreteNewTweetScreen> {
  final createNewTweetTextController = TextEditingController();
  List<File> images = [];

  Future<void> onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  void dispose() {
    createNewTweetTextController.dispose();
    super.dispose();
  }

  void createNewTweet() {
    final res = ref.read(tweetControllerProvider.notifier).createNewTweet(
          images: images,
          text: createNewTweetTextController.text,
          context: context,
          repliedToTheTweetId: '',
          repliedToTheUserId: '',
        );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('called in: create_new_tweet.dart');
    final currentUser = ref.watch(loggedInUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: RoundedChipButton(
              label: 'Tweet',
              onTapCallback: createNewTweet,
              backgroundColor: Pallete.blueColor,
              textColor: Pallete.whiteColor,
            ),
          ),
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              AppWriteConstants.endPoint + currentUser.profilePic,
                            ),
                            radius: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              controller: createNewTweetTextController,
                              maxLines: null,
                              style: const TextStyle(
                                fontSize: 22,
                              ),
                              decoration: const InputDecoration(
                                hintText: "What's happening?",
                                hintStyle: TextStyle(
                                  color: Pallete.greyColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map((file) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Image.file(file),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
              child: GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(
                  AssetsConstants.galleryIcon,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(
                AssetsConstants.gifIcon,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(
                AssetsConstants.emojiIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
