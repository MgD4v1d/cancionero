import 'package:cancioneroruah/domain/entities/song/song.dart';
import 'package:cancioneroruah/infrastructure/models/song_model.dart';

class SongMapper {
  
  static Song toDomain(SongModel model) => Song(
    id: model.id, 
    title: model.title, 
    artist: model.artist, 
    lyrics: model.lyrics,
    videoUrl: model.videoUrl,
  );
  

  static SongModel toModel(Song song) => SongModel(
    id: song.id, 
    title: song.title, 
    artist: song.artist, 
    lyrics: song.lyrics,
    videoUrl: song.videoUrl,
  );
  
}