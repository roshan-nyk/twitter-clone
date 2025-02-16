import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:roshan_twitter_clone/features/tweet/view/hashtag_view.dart';
import 'package:roshan_twitter_clone/theme/pallete.dart';

class HashTagText extends StatelessWidget {
  const HashTagText({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpan = [];

    TapGestureRecognizer onTapHashTag(String element) {
      return TapGestureRecognizer()
        ..onTap = () {
          Navigator.push(context, HashtagView.route(hashTag: element));
        };
    }

    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textSpan.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            recognizer: onTapHashTag(element),
          ),
        );
      } else if (element.startsWith('www.') || element.startsWith('WWW.') || element.startsWith('https://')) {
        textSpan.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
            ),
          ),
        );
      } else {
        textSpan.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        );
      }
    });
    return RichText(
      text: TextSpan(
        children: textSpan,
      ),
    );
  }
}
