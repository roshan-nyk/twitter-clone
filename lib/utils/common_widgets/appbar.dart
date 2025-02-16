import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roshan_twitter_clone/theme/pallete.dart';

class ReUsableAppBar {
  static AppBar appBar([String? titleLogo, String? titleText]) {
    return AppBar(
      title: titleLogo != null
          ? SvgPicture.asset(
              titleLogo,
              color: Pallete.blueColor,
              height: 30,
            )
          : titleText != null
              ? Text(titleText)
              : null,
      centerTitle: true,
    );
  }
}
