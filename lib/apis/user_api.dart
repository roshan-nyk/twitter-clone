import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:roshan_twitter_clone/constants/constants.dart';
import 'package:roshan_twitter_clone/core/core.dart';
import 'package:roshan_twitter_clone/core/providers.dart';
import 'package:roshan_twitter_clone/model/user_model.dart';

final userApiProvider = Provider<UserApi>((ref) {
  final db = ref.watch(appWriteDatabaseProvider);
  // final realtime = ref.watch(appWriteRealtimeProvider);
  final client = ref.watch(appWriteClientProvider);
  final realtime = Realtime(client);
  return UserApi(db: db, realtime: realtime);
});

abstract class IUserApi {
  FutureEitherVoid saveUserData(UserModel userModel);
  FutureEitherVoid updateUserData(UserModel userModel);
  Future<model.Document> getUserData(String uid);
  Future<List<model.Document>> getUsersForSearchValue(String searchValue);
  Stream<RealtimeMessage> getRealTimeUserProfileData(String uid);
}

class UserApi implements IUserApi {
  const UserApi({
    required Databases db,
    required Realtime realtime,
  })  : _db = db,
        _realtime = realtime;

  final Databases _db;
  final Realtime _realtime;

  @override
  Stream<RealtimeMessage> getRealTimeUserProfileData(String uid) async* {
    try {
      final result = _realtime.subscribe([
        'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.userCollectionId}.documents.${uid}',
      ]).stream;
      await for (final data in result) {
        debugPrint("======= "+data.events.toString());
        yield data;
      }
    } on AppwriteException catch (e, stackTrace) {
      debugPrint(e.response.toString());
    } on Exception catch (e, stackTrace) {
      debugPrint(e.toString());
    }
  }

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, stacktrace) {
      return left(Failure(e.message ?? 'AppWrite Exception', stacktrace));
    } on Exception catch (e, stacktrace) {
      return left(Failure(e.toString(), stacktrace));
    }
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, stacktrace) {
      debugPrint(e.response.toString());
      return left(Failure(e.message ?? 'AppWrite Exception', stacktrace));
    } on Exception catch (e, stacktrace) {
      return left(Failure(e.toString(), stacktrace));
    }
  }

  @override
  Future<model.Document> getUserData(String uid) async {
    final res = await _db.getDocument(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userCollectionId,
      documentId: uid,
    );
    return res;
  }

  @override
  Future<List<model.Document>> getUsersForSearchValue(String searchValue) async {
    final res = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userCollectionId,
      queries: [
        Query.search('name', searchValue) as String,
      ],
    );
    return res.documents;
  }
}
