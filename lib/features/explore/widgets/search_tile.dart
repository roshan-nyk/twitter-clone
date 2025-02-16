import 'package:flutter/material.dart';
import 'package:roshan_twitter_clone/constants/appwrite_constants.dart';
import 'package:roshan_twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:roshan_twitter_clone/model/user_model.dart';
import 'package:roshan_twitter_clone/theme/pallete.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({required this.userModel, super.key});

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        onTap: () => Navigator.of(context).push(UserProfileView.route(userModel)),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(AppWriteConstants.endPoint + userModel.profilePic),
          radius: 30,
        ),
        title: Text(
          userModel.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '@${userModel.name}',
              style: const TextStyle(
                fontSize: 16,
                color: Pallete.greyColor,
              ),
            ),
            if (userModel.bio.isNotEmpty)
              Text(
                userModel.bio,
                style: const TextStyle(
                  fontSize: 16,
                  color: Pallete.whiteColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
