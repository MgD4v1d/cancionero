import 'package:cancioneroruah/domain/entities/song/repertoire.dart';

abstract class RepertoireRepository {
  Future<List<Repertoire>> getUserRepertoires(String userId);
  Future<void> addRepertoire(Repertoire repertoire);
  Future<void> updateRepertoire(Repertoire repertoire);
  Future<void> deleteRepertoire(String id);
}