import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/constants/appwrite_constants.dart';
import 'package:roshan_twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:roshan_twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:roshan_twitter_clone/theme/pallete.dart';
import 'package:roshan_twitter_clone/utils/common_functions.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/common_widgets.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({
    super.key,
  });

  static MaterialPageRoute<EditProfileView> route() => MaterialPageRoute(builder: (context) => const EditProfileView());

  @override
  ConsumerState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late final TextEditingController userNameController;
  late final TextEditingController bioController;
  File? bannerFile;
  File? profileFile;

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController(text: ref.read(loggedInUserDetailsProvider).value?.name ?? '');
    bioController = TextEditingController(text: ref.read(loggedInUserDetailsProvider).value?.bio ?? '');
  }

  @override
  void dispose() {
    userNameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  Future<void> selectProfilePic() async {
    final picture = await pickImage();
    if (picture != null) {
      setState(() {
        profileFile = picture;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(loggedInUserDetailsProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: () {
                ref.read(userProfileControllerProvider.notifier).updateUserProfile(
                      userModel: user!.copyWith(
                        name: userNameController.text,
                        bio: bioController.text,
                      ),
                      bannerFile: bannerFile,
                      profileFile: profileFile,
                      context: context,
                    );
              },
              style: TextButton.styleFrom(
                backgroundColor: Pallete.whiteColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 25),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Pallete.backgroundColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading || user == null
          ? const Loader()
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: selectBannerImage,
                            child: bannerFile != null
                                ? Image.file(
                                    bannerFile!,
                                    fit: BoxFit.fitWidth,
                                  )
                                : user.bannerPic.isEmpty
                                    ? Container(
                                        color: Pallete.blueColor,
                                      )
                                    : Image.network(
                                        AppWriteConstants.endPoint + user.bannerPic,
                                        fit: BoxFit.fitWidth,
                                      ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          left: 20,
                          child: GestureDetector(
                            onTap: selectProfilePic,
                            child: profileFile != null
                                ? CircleAvatar(
                                    backgroundImage: FileImage(profileFile!),
                                    radius: 35,
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      AppWriteConstants.endPoint + user.profilePic,
                                    ),
                                    radius: 35,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextField(
                          controller: userNameController,
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            contentPadding: EdgeInsets.all(18),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: bioController,
                          decoration: const InputDecoration(
                            hintText: 'Bio',
                            contentPadding: EdgeInsets.all(18),
                          ),
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
