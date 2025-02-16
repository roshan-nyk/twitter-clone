import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/constants/appwrite_constants.dart';
import 'package:roshan_twitter_clone/core/providers.dart';

final storageAPIProvider = Provider((ref) {
  final storage = ref.watch(appWriteStorageProvider);
  return StorageAPI(storage: storage);
});

class StorageAPI {
  StorageAPI({required Storage storage}) : _storage = storage;
  final Storage _storage;

  Future<List<String>> uploadImages(List<File> imageFiles) async {
    final imageLinks = <String>[];
    for (final file in imageFiles) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppWriteConstants.imageBucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      imageLinks.add(AppWriteConstants.imageUrl(uploadedImage.$id));
    }
    return imageLinks;
  }
}
