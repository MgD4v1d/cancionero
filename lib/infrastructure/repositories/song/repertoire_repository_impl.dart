
import 'package:cancioneroruah/domain/entities/song/repertoire.dart';
import 'package:cancioneroruah/domain/repositories/song/repertoire_repository.dart';
import 'package:cancioneroruah/infrastructure/infrastructure.dart';
import 'package:cancioneroruah/infrastructure/mappers/song/repertoire_mapper.dart';

class RepertoireRepositoryImpl extends RepertoireRepository{

  final RepertoireDatasource datasource;

  RepertoireRepositoryImpl(this.datasource);

  @override
  Future<void> addRepertoire(Repertoire repertoire) async{
    final model = RepertoireMapper.toModel(repertoire);
    await datasource.addRepertoire(model);
  }

  @override
  Future<void> deleteRepertoire(String id) async{
    await datasource.deleteRepertoire(id);
  }

  @override
  Future<List<Repertoire>> getUserRepertoires(String userId) async{
    final models = await datasource.getUserRepertoires(userId);
    return models.map(RepertoireMapper.toEntity).toList();
  }

  @override
  Future<void> updateRepertoire(Repertoire repertoire) async {
    final model = RepertoireMapper.toModel(repertoire);
    await datasource.updateRepertoire(model);
  }



 
}