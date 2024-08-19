
import 'package:cancioneroruah/domain/entities/song/repertoire.dart';
import 'package:cancioneroruah/domain/repositories/song/repertoire_repository.dart';
import 'package:cancioneroruah/infrastructure/infrastructure.dart';
import 'package:cancioneroruah/infrastructure/mappers/song/repertoire_mapper.dart';

class RepertoireRepositoryImpl extends RepertoireRepository{

  final RepertoireDatasource datasource;

  RepertoireRepositoryImpl(this.datasource);

  @override
  Future<String> addRepertoire(Repertoire repertoire) async{
    final model = RepertoireMapper.toModel(repertoire);
    final documentId = await datasource.addRepertoire(model);
    return documentId;

  }

  @override
  Future<void> deleteRepertoire(String repertoireId) async{
    await datasource.deleteRepertoire(repertoireId);
  }

  @override
  Future<List<Repertoire>> getUserRepertoires(String userId) async{
    final models = await datasource.getUserRepertoires(userId);
    return models.map(RepertoireMapper.toEntity).toList();
  }

  @override
  Future<void> updateRepertoire(String repertoireId, Repertoire repertoire) async{
    final model = RepertoireMapper.toModel(repertoire);
    await datasource.updateRepertoire(repertoireId, model);
  }

  @override
  Future<void> updateSongsToRepertoire(String repertoireId, List<String> songIds) async {
    await datasource.updateSongsToRepertoire(repertoireId, songIds);
  }
  
  @override
  Future<void> removeSongFromRepertoire(String repertoireId, String songId) async{
    await datasource.removeSongFromRepertoire(repertoireId, songId);
  }
  
  @override
  Future<void> updateSongOrder(String repertoireId, List<String> newOrder) async{
    await datasource.updateSongOrder(repertoireId, newOrder);
  }
  
  @override
  Future<Repertoire> getRepertoireById(String id) async{
    final repertoire = await datasource.getRepertoireById(id);
    return RepertoireMapper.toEntity(repertoire);
  }
  
  @override
  Future<void> updateRepertoireTitle(String repertoireId, String newTitle) async {
    await datasource.updateRepertoireTitle(repertoireId, newTitle);
  }
      
 
}