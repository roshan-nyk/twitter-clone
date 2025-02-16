import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:roshan_twitter_clone/constants/appwrite_constants.dart';
import 'package:roshan_twitter_clone/core/core.dart';
import 'package:roshan_twitter_clone/core/providers.dart';
import 'package:roshan_twitter_clone/model/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  final db = ref.watch(appWriteDatabaseProvider);
  // final realtime = ref.watch(appWriteRealtimeProvider);
  final client = ref.watch(appWriteClientProvider);
  final realtime = Realtime(client);
  return TweetAPI(db: db, realtime: realtime);
});

abstract class ITweetAPI {
  FutureEither<Document> createNewTweet(Tweet tweet);
  Future<List<Document>> getTweets();
  Future<List<Document>> getTweetsByHashtag(String hashTag);
  Stream<RealtimeMessage> getRealTimeNewTweets();
  Stream<RealtimeMessage> getRealTimeUpdatedTweets();
  FutureEither<Document> likeTweet(Tweet tweet);
  FutureEither<Document> updateReTweetCount(Tweet tweet);
  Future<List<Document>> getRepliesToTweet(Tweet tweet);
  Future<Document> getTweetById(String tweetId);
  Future<List<Document>> getTweetsByUser(String uid);
}

class TweetAPI implements ITweetAPI {
   TweetAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  final Databases _db;
  late  Realtime _realtime;
   RealtimeSubscription? _tweetSubscription;

  @override
  FutureEither<Document> createNewTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollectionId,
        documentId: ID.unique(), // Every new tweet should have a new Id
        data: tweet.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, stacktrace) {
      debugPrint(e.response.toString());
      return left(Failure(e.message ?? 'AppWrite Exception', stacktrace));
    } on Exception catch (e, stacktrace) {
      debugPrint(e.toString());
      return left(Failure(e.toString(), stacktrace));
    }
  }

  @override
  Future<List<Document>> getTweets() async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollectionId,
      queries: [
        Query.orderDesc('tweetedAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getRealTimeNewTweets() async* {
    try {
      _tweetSubscription ??= _realtime
            .subscribe([
          'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.tweetsCollectionId}.documents',
        ]);

        await for (final data in _tweetSubscription!.stream) {
          debugPrint('======= ${data.events}');
          final isNewTweet = data.events.contains(
            'databases.*'
                '.collections.${AppWriteConstants.tweetsCollectionId}'
                '.documents.*.create',
          ) ||
              data.events.contains(
                'databases.*'
                    '.collections.${AppWriteConstants.tweetsCollectionId}'
                    '.documents.*.delete',
              );
          if (isNewTweet) {
            yield data;
          }
        }

    } on AppwriteException catch (e, stackTrace) {
      debugPrint(e.response.toString());
    } on Exception catch (e, stackTrace) {
      debugPrint(e.toString());
    }
  }

  @override
  Stream<RealtimeMessage> getRealTimeUpdatedTweets() async* {
    try {
      debugPrint('called in: tweet_api.dart' ' updateTweet');
      _tweetSubscription ??= _realtime
          .subscribe([
        'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.tweetsCollectionId}.documents',
      ]);

      await for (final data in _tweetSubscription!.stream) {
        final isUpdatedTweet = data.events.contains(
          'databases.*'
          '.collections.${AppWriteConstants.tweetsCollectionId}'
          '.documents.*.update',
        );
        if (isUpdatedTweet) {
          yield data;
        }
      }
    } on AppwriteException catch (e, stackTrace) {
      debugPrint('Roshan Update Tweet');
      debugPrint(e.response.toString());
    } on Exception catch (e, stackTrace) {
      debugPrint(e.toString());
    }
  }

  @override
  FutureEither<Document> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollectionId,
        documentId: tweet.id,
        data: {
          'likes': tweet.likes,
        },
      );
      return right(document);
    } on AppwriteException catch (e, stacktrace) {
      debugPrint(e.response.toString());
      return left(Failure(e.message ?? 'AppWrite Exception', stacktrace));
    } on Exception catch (e, stacktrace) {
      debugPrint(e.toString());
      return left(Failure(e.toString(), stacktrace));
    }
  }

  @override
  FutureEither<Document> updateReTweetCount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollectionId,
        documentId: tweet.id,
        data: {
          'reTweetCount': tweet.reTweetCount,
        },
      );
      return right(document);
    } on AppwriteException catch (e, stacktrace) {
      debugPrint(e.response.toString());
      return left(Failure(e.message ?? 'AppWrite Exception', stacktrace));
    } on Exception catch (e, stacktrace) {
      debugPrint(e.toString());
      return left(Failure(e.toString(), stacktrace));
    }
  }

  @override
  Future<List<Document>> getRepliesToTweet(Tweet tweet) async {
    final document = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollectionId,
      queries: [
        Query.equal('repliedTo', tweet.id) as String,
      ],
    );

    return document.documents;
  }

  @override
  Future<Document> getTweetById(String tweetId) async {
    final document = await _db.getDocument(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollectionId,
      documentId: tweetId,
    );

    return document;
  }

  @override
  Future<List<Document>> getTweetsByUser(String uid) async {
    final document = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollectionId,
      queries: [
        Query.equal('uid', uid) as String,
        Query.orderDesc('tweetedAt'),
      ],
    );

    return document.documents;
  }

  @override
  Future<List<Document>> getTweetsByHashtag(String hashTag) async {
    final document = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollectionId,
      queries: [
        Query.search('hashTags', hashTag) as String,
        Query.orderDesc('tweetedAt'),
      ],
    );

    debugPrint(document.documents.toString());

    return document.documents;
  }
}
