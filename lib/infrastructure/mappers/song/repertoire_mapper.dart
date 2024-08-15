import 'package:cancioneroruah/domain/entities/song/repertoire.dart';
import 'package:cancioneroruah/infrastructure/models/repertoire_model.dart';

class RepertoireMapper{


  static RepertoireModel toModel(Repertoire repertoire) => RepertoireModel(
      id: repertoire.id, 
      userId: repertoire.userId, 
      title: repertoire.title, 
      songIds: repertoire.songIds,
    );
  

  static Repertoire toEntity(RepertoireModel model){

    return Repertoire(
      id: model.id, 
      userId: model.userId, 
      title: model.title, 
      songIds: model.songIds
    );

  }
}