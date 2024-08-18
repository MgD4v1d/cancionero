import 'package:cancioneroruah/domain/entities/song/repertoire.dart';

abstract class RepertoireRepository {
  Future<Repertoire> getRepertoireById(String id);
  Future<List<Repertoire>> getRepetoiresById(String userId);
  Future<List<Repertoire>> getUserRepertoires(String userId);
  Future<void> addRepertoire(Repertoire repertoire);
  Future<void> deleteRepertoire(String repertoireId);
  Future<void> updateRepertoire(String repertoireId, List<String> songIds);
  Future<void> removeSongFromRepertoire(String repertoireId, String songId);
  Future<void> updateSongOrder(String repertoireId, List<String> newOrder);
   Future<void> updateRepertoireTitle(String repertoireId, String newTitle);
}