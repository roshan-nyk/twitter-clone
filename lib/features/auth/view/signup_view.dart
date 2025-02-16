import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/constants/asset_constants.dart';
import 'package:roshan_twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:roshan_twitter_clone/features/auth/view/login_view.dart';
import 'package:roshan_twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:roshan_twitter_clone/theme/pallete.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/common_widgets.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  static MaterialPageRoute<SignUpView> route() => MaterialPageRoute(builder: (context) => const SignUpView());

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final appBar = ReUsableAppBar.appBar(AssetsConstants.twitterLogo);

  void onDispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onSignUp() {
    ref.read(authControllerProvider.notifier).signUp(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: appBar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      AuthField(
                        editingController: emailController,
                        hintText: 'Email address',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthField(
                        editingController: passwordController,
                        hintText: 'Password',
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: RoundedChipButton(
                          onTapCallback: onSignUp,
                          label: 'Done',
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: const TextStyle(fontSize: 16),
                          children: [
                            TextSpan(
                              text: 'Log in',
                              style: const TextStyle(
                                color: Pallete.blueColor,
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(context, LoginView.route());
                                },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
