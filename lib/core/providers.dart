import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roshan_twitter_clone/constants/constants.dart';

final appWriteClientProvider = Provider((ref) {
  final client = Client();
  return client.setEndpoint(AppWriteConstants.endPoint).setProject(AppWriteConstants.projectId).setSelfSigned();
});

final appWriteAccountProvider = Provider<Account>((ref) {
  final client = ref.watch(appWriteClientProvider);
  return Account(client);
});

final appWriteDatabaseProvider = Provider<Databases>((ref) {
  final client = ref.watch(appWriteClientProvider);
  return Databases(client);
});

final appWriteStorageProvider = Provider<Storage>((ref) {
  final client = ref.watch(appWriteClientProvider);
  return Storage(client);
});

// final appWriteRealtimeProvider = Provider<Realtime>((ref) {
//   final client = ref.read(appWriteClientProvider);
//   return Realtime(client);
// });
