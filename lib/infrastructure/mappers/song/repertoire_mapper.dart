import 'package:cancioneroruah/domain/entities/song/repertoire.dart';
import 'package:cancioneroruah/domain/entities/song/song.dart';
import 'package:cancioneroruah/infrastructure/models/repertoire_model.dart';
import 'package:cancioneroruah/infrastructure/models/song_model.dart';

class RepertoireMapper{


  static RepertoireModel toModel(Repertoire repertoire) => RepertoireModel(
      id: repertoire.id, 
      userId: repertoire.userId, 
      name: repertoire.name, 
      songs: repertoire.songs.map((song) => SongModel(
        id: song.id, 
        title: song.title, 
        artist: song.artist, 
        lyrics: song.lyrics
      )).toList(),
    );
  

  static Repertoire toEntity(RepertoireModel model){

    return Repertoire(
      id: model.id, 
      userId: model.userId, 
      name: model.name, 
      songs: model.songs.map((song) => Song(
        id: song.id, 
        title: song.title, 
        artist: song.artist, 
        lyrics: song.lyrics
      )).toList(),
    );

  }
}