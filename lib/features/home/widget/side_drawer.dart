import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roshan_twitter_clone/constants/asset_constants.dart';
import 'package:roshan_twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:roshan_twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:roshan_twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/common_widgets.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('called in: side_drawer.dart');
    final user = ref.watch(loggedInUserDetailsProvider).value;
    return user == null
        ? const Loader()
        : ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 30,
                ),
                title: const Text(
                  'My Profile',
                  style: TextStyle(fontSize: 22),
                ),
                onTap: () {
                  Navigator.push(context, UserProfileView.route(user));
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  AssetsConstants.verifiedIcon,
                  width: 30,
                  height: 30,
                ),
                title: const Text(
                  'Twitter Blue',
                  style: TextStyle(fontSize: 22),
                ),
                onTap: () {
                  ref.read(userProfileControllerProvider.notifier).updateUserProfile(
                        userModel: user.copyWith(isTwitterBlue: true),
                        bannerFile: null,
                        profileFile: null,
                        context: context,
                      );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  size: 30,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 22),
                ),
                onTap: () {
                  ref.read(authControllerProvider.notifier).logOut(context);
                },
              ),
            ],
          );
  }
}
