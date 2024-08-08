import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cancioneroruah/domain/domain.dart';
import 'package:cancioneroruah/domain/entities/song/song.dart';
import 'package:cancioneroruah/infrastructure/infrastructure.dart';

// final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// final songDatasourceProvider = Provider((ref) => SongDatasource(ref.watch(firestoreProvider)));

// final songRepositoryProvider = Provider((ref) => SongRepositoryImpl(ref.watch(songDatasourceProvider)));

// final allSongsProvider = FutureProvider<List<Song>>((ref) async {
//   return ref.watch(songRepositoryProvider).getAllSongs();
// });

// final songProvider = FutureProvider.family<Song, String>((ref, songId) async {
//   final repository = ref.watch(songRepositoryProvider);
//   return repository.getSongById(songId);
// });

final songRepositoryProvider = Provider<SongRepository>((ref) {
  final songDataSource = SongDatasource(FirebaseFirestore.instance);
  return SongRepositoryImpl(songDataSource);
});

final allSongsProvider = FutureProvider<List<Song>>((ref) async {
  final repository = ref.watch(songRepositoryProvider);
  return repository.getAllSongs();
});

final songProvider = FutureProvider.family<Song, String>((ref, id) async {
  final repository = ref.watch(songRepositoryProvider);
  return repository.getSongById(id);
});

final songsRefreshProvider = FutureProvider.autoDispose<List<Song>>((ref) async {
  final songRepository = ref.read(songRepositoryProvider);
  return await songRepository.getAllSongs();
});

final songsCountProvider = FutureProvider<int>((ref) async {
  final songRepository = ref.read(songRepositoryProvider);
  return await songRepository.getSongsCount();
});

final textSizeProvider = StateNotifierProvider<TextSizeNotifier, double>((ref) {
  return TextSizeNotifier();
});

class TextSizeNotifier extends StateNotifier<double> {
  TextSizeNotifier() : super(16.0);

  void increaseTextSize() {
    if (state < 32.0) state += 2.0;
  }

  void decreaseTextSize() {
    if (state > 12.0) state -= 2.0;
  }
}



