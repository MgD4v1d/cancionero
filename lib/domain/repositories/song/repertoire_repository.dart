import 'package:cancioneroruah/domain/entities/song/repertoire.dart';

abstract class RepertoireRepository {
  // Future<List<Repertoire>> getUserRepertoires(String userId);
  // Future<void> addRepertoire(Repertoire repertoire);
  // Future<void> updateRepertoire(Repertoire repertoire);
  // Future<void> deleteRepertoire(String id);

  Future<List<Repertoire>> getUserRepertoires(String userId);
  Future<void> addRepertoire(Repertoire repertoire);
  Future<void> deleteRepertoire(String repertoireId);
  Future<void> updateRepertoire(String repertoireId, List<String> songIds);
  Future<void> removeSongFromRepertoire(String repertoireId, String songId);
}