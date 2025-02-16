import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roshan_twitter_clone/theme/pallete.dart';

class TweetIconButton extends StatelessWidget {
  const TweetIconButton({
    required this.pathName,
    required this.text,
    required this.onTap,
    super.key,
  });
  final String pathName;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          if (pathName.isNotEmpty) ...[
            SvgPicture.asset(
              pathName,
              color: Pallete.greyColor,
            ),
            Container(
              margin: const EdgeInsets.all(6),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
          if (pathName.isEmpty)
            const Icon(
              Icons.share_outlined,
              color: Pallete.greyColor,
            ),
        ],
      ),
    );
  }
}
