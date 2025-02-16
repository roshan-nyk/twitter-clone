import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:roshan_twitter_clone/core/core.dart';
import 'package:roshan_twitter_clone/core/providers.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  final account = ref.watch(appWriteAccountProvider);
  return AuthApi(account: account);
});

// In AppWrite
// want to signup, want to get user account -> Account
// want to access user related data -> model.User

abstract class IAuthApi {
  FutureEither<model.User> signUp({
    required String email,
    required String password,
  });

  FutureEither<model.Session> logIn({
    required String email,
    required String password,
  });

  Future<model.User?> currentUserAccount();

  FutureEitherVoid logOut();
}

class AuthApi implements IAuthApi {
  AuthApi({required Account account}) : _account = account;

  final Account _account;

  // This code snippet retrieves the current user's account information using the `_account.get()` method.
  // If an `AppwriteException` occurs, it prints the exception response and stack trace.
  // If any other exception occurs, it prints the exception and stack trace.

  @override
  Future<model.User?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException catch (e, stacktrace) {
      debugPrint('${e.response}\n$stacktrace');
      return null;
    } on Exception catch (e, stacktrace) {
      debugPrint('$e\n$stacktrace');
      return null;
    }
  }

  @override
  FutureEither<model.User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return right(account);
    } on AppwriteException catch (e, stacktrace) {
      return left(
        Failure(e.message ?? 'AppWrite Exception', stacktrace),
      );
    } on Exception catch (e, stacktrace) {
      return left(
        Failure(e.toString(), stacktrace),
      );
    }
  }

  @override
  FutureEither<model.Session> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _account.createEmailSession(
        email: email,
        password: password,
      );
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.response.toString(), stackTrace),
      );
    } on Exception catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEitherVoid logOut() async {
    try {
      await _account.deleteSession(
        sessionId: 'current',
      );
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'AppWrite Exception', stackTrace),
      );
    } on Exception catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}
