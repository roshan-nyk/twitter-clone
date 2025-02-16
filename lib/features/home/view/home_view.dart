import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roshan_twitter_clone/constants/constants.dart';
import 'package:roshan_twitter_clone/features/explore/view/explore_view.dart';
import 'package:roshan_twitter_clone/features/home/widget/side_drawer.dart';
import 'package:roshan_twitter_clone/features/notification/view/notification_view.dart';
import 'package:roshan_twitter_clone/features/tweet/view/create_new_tweet_view.dart';
import 'package:roshan_twitter_clone/features/tweet/widgets/tweet_list.dart';
import 'package:roshan_twitter_clone/theme/pallete.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/appbar.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/common_widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  static MaterialPageRoute<HomeView> route() => MaterialPageRoute(builder: (context) => const HomeView());

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomeView> {
  int _bottomNavPageIndex = 0;

  void updateBottomNavPageIndex(int selectedIndex) {
    setState(() {
      _bottomNavPageIndex = selectedIndex;
    });
  }

  void onCreateTweet() {
    Navigator.of(context).push(CreteNewTweetScreen.route());
  }

  void onPageChange(int index) {
    setState(() {
      _bottomNavPageIndex = index;
    });
  }

  List<Widget> bottomTabBarPages = [
    TweetList(
      copyTweetList: [],
    ),
    const ExploreView(),
    const NotificationView(),
  ];

  @override
  Widget build(BuildContext context) {
    // The code snippet creates a basic structure or framework for a software application, providing a starting point for development.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _bottomNavPageIndex == 0 ? ReUsableAppBar.appBar(AssetsConstants.twitterLogo) : null,
      drawer: const SideDrawer(),
      // drawerEnableOpenDragGesture : ,
      body: IndexedStack(
        index: _bottomNavPageIndex,
        children: bottomTabBarPages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateTweet,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavPageIndex,
        backgroundColor: Pallete.backgroundColor,
        onTap: onPageChange,
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: GestureDetector(
              onTap: () => updateBottomNavPageIndex(0),
              child: SvgPicture.asset(
                _bottomNavPageIndex == 0 ? AssetsConstants.homeFilledIcon : AssetsConstants.homeOutlinedIcon,
                color: Pallete.whiteColor,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: GestureDetector(
              onTap: () => updateBottomNavPageIndex(1),
              child: SvgPicture.asset(
                AssetsConstants.searchIcon,
                color: Pallete.whiteColor,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: GestureDetector(
              onTap: () => updateBottomNavPageIndex(2),
              child: SvgPicture.asset(
                _bottomNavPageIndex == 2 ? AssetsConstants.notifFilledIcon : AssetsConstants.notifOutlinedIcon,
                color: Pallete.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
