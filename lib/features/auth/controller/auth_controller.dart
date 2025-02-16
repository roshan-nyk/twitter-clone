import 'package:appwrite/models.dart' as model;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/apis/auth_api.dart';
import 'package:roshan_twitter_clone/apis/user_api.dart';
import 'package:roshan_twitter_clone/features/auth/view/login_view.dart';
import 'package:roshan_twitter_clone/features/home/view/home_view.dart';
import 'package:roshan_twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:roshan_twitter_clone/model/user_model.dart';
import 'package:roshan_twitter_clone/utils/common_functions.dart';

final authControllerProvider = StateNotifierProvider.autoDispose<AuthController, bool>((ref) {
  final authApi = ref.watch(authApiProvider);
  final userApi = ref.watch(userApiProvider);
  return AuthController(authAPI: authApi, userApi: userApi);
});

final loggedInUserDetailsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(loggedInUserAccountProvider).when(
        data: (data) {
          if (data != null) {
            final currentUserId = data.$id;
            final userDetails = ref.watch(
              getUserDetailsByUserIdProvider(currentUserId),
            );
            return userDetails.value;
          } else {
            ref.invalidate(loggedInUserAccountProvider);
          }
          return null;
        },
        error: (error, st) => null,
        loading: () => null,
      );
  // final currentUserId = ref.watch(loggedInUserAccountProvider).value!.$id;
  // final userDetails = ref.watch(getUserDetailsByUserIdProvider(currentUserId));
  // return userDetails.value;
});

final getUserDetailsByUserIdProvider = FutureProvider.autoDispose.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  ref.watch(getRealTimeUserProfileDataProvider(uid));
  return authController.getUserData(uid);
});

final loggedInUserAccountProvider = FutureProvider.autoDispose((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  final res = authController.currentUser();
  res.asStream().listen((account) {
    debugPrint('LoggedInAccount:-  $account');
  });
  return res;
});

class AuthController extends StateNotifier<bool> {
  AuthController({required AuthApi authAPI, required UserApi userApi})
      : _authAPI = authAPI,
        _userApi = userApi,
        super(false);
  final AuthApi _authAPI;
  final UserApi _userApi;

  Future<model.User?> currentUser() {
    return _authAPI.currentUserAccount();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final signUpResult = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    signUpResult.fold((l) => showSnackBar(context, l.message), (r) async {
      debugPrint(r.email);
      final userModel = UserModel(
        email: email,
        name: getNameFromEmail(email),
        followers: const [],
        following: const [],
        profilePic: '',
        bannerPic: '',
        uid: r.$id,
        bio: '',
        isTwitterBlue: false,
      );
      final saveNewUserResult = await _userApi.saveUserData(userModel);
      saveNewUserResult.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Account Created Successfully');
        Navigator.of(context).push(LoginView.route());
      });
    });
  }

  Future<void> logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.logIn(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      debugPrint(r.userId);
      showSnackBar(context, 'LogIn Successfully');
      Navigator.pushAndRemoveUntil(context, HomeView.route(), (route) => false);
    });
  }

  Future<UserModel> getUserData(String id) async {
    final document = await _userApi.getUserData(id);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }

  Future<void> logOut(BuildContext context) async {
    final result = await _authAPI.logOut();
    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pushAndRemoveUntil(
        context,
        LoginView.route(),
        (route) => false,
      ),
    );
  }
}
