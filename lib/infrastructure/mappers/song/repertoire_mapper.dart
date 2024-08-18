import 'package:cancioneroruah/domain/entities/song/repertoire.dart';
import 'package:cancioneroruah/infrastructure/models/repertoire_model.dart';

class RepertoireMapper{

  static Repertoire fromMap(Map<String, dynamic> map){
    return Repertoire(
      id: map['id'] as String, 
      title: map['title'] as String, 
      userId: map['userId'] as String, 
      songIds: List<String>.from(map['songIds'] as List<dynamic>),
    );
  }

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