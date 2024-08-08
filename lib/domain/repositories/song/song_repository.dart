import 'package:cancioneroruah/domain/entities/song/song.dart';

abstract class SongRepository {
  
  Future<List<Song>> getAllSongs();

  Future<Song> getSongById(String id);

  Future<int> getSongsCount();
}