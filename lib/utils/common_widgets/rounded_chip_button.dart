import 'package:flutter/material.dart';
import 'package:roshan_twitter_clone/theme/pallete.dart';

class RoundedChipButton extends StatelessWidget {
  const RoundedChipButton({
    required this.label,
    required this.onTapCallback,
    super.key,
    this.backgroundColor = Pallete.whiteColor,
    this.textColor = Pallete.backgroundColor,
  });

  final String label;
  final VoidCallback onTapCallback;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapCallback,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
        backgroundColor: backgroundColor,
        labelPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }
}
