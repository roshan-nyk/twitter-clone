import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:roshan_twitter_clone/features/auth/view/signup_view.dart';
import 'package:roshan_twitter_clone/features/home/view/home_view.dart';
import 'package:roshan_twitter_clone/theme/theme.dart';
import 'package:roshan_twitter_clone/utils/common_widgets/common_widgets.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Twitter Clone',
      theme: AppTheme.theme,
      home: ref.watch(loggedInUserAccountProvider).when(
            data: (user) {
              return user != null ? const HomeView() : const SignUpView();
            },
            error: (error, st) => ErrorPage(errorText: error.toString()),
            loading: LoadingPage.new,
          ),
    );
  }
}
