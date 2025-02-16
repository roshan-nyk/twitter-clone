import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/features/explore/controller/explore_controller.dart';
import 'package:roshan_twitter_clone/features/explore/widgets/search_tile.dart';
import 'package:roshan_twitter_clone/theme/theme.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/common_widgets.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({
    super.key,
  });

  @override
  ConsumerState createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  late TextEditingController searchTextFieldController;
  late OutlineInputBorder searchFieldBorder;

  @override
  void initState() {
    super.initState();
    searchTextFieldController = TextEditingController();
    searchFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Pallete.searchBarColor,
      ),
      borderRadius: BorderRadius.circular(50),
    );
  }

  @override
  void dispose() {
    searchTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            height: 50,
            child: TextField(
              controller: searchTextFieldController,
              onSubmitted: (searchValue) {
                setState(() {});
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Pallete.searchBarColor,
                contentPadding: const EdgeInsets.all(10).copyWith(left: 20),
                hintText: 'Search Twitter',
                enabledBorder: searchFieldBorder,
                focusedBorder: searchFieldBorder,
              ),
            ),
          ),
        ),
      ),
      body: searchTextFieldController.text.isEmpty
          ? const SizedBox.shrink()
          : ref.watch(searchUserProvider(searchTextFieldController.text)).when(
                data: (userList) {
                  return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final currentUser = userList[index];
                      return SearchTile(userModel: currentUser);
                    },
                  );
                },
                error: (er, st) => ErrorText(errorText: er.toString()),
                loading: () => const Loader(),
              ),
    );
  }
}
