import 'package:flutter/material.dart';
import 'package:roshan_twitter_clone/theme/pallete.dart';

class FollowCount extends StatelessWidget {
  const FollowCount({required this.text, required this.count, super.key});

  final String text;
  final int count;

  @override
  Widget build(BuildContext context) {
    const fontSize = 18.0;
    return Row(
      children: [
        Text(
          '$count ',
          style: const TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Pallete.whiteColor,
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: fontSize,
            color: Pallete.greyColor,
          ),
        ),
      ],
    );
  }
}
