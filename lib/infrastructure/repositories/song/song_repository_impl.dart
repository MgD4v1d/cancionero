
import 'package:cancioneroruah/domain/domain.dart';
import 'package:cancioneroruah/infrastructure/infrastructure.dart';
import 'package:cancioneroruah/infrastructure/mappers/song/song_mapper.dart';

class SongRepositoryImpl implements SongRepository {
  
  final SongDatasource datasource;

  SongRepositoryImpl(this.datasource);

  @override
  Future<List<Song>> getAllSongs() async {
    final songModels = await datasource.getAllSongs();
    return songModels.map((model) => SongMapper.toDomain(model)).toList();
  }
  
  @override
  Future<Song> getSongById(String id) async {
    final songModel = await datasource.getSongById(id);
    return SongMapper.toDomain(songModel);
  }
  
  @override
  Future<int> getSongsCount() async {
    final songModel = await datasource.getSongsCount();
    return songModel;
  }

}