import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cancioneroruah/domain/domain.dart';
import 'package:cancioneroruah/presentation/providers/song/song_provider.dart';
import 'package:cancioneroruah/domain/repositories/song/repertoire_repository.dart';
import 'package:cancioneroruah/presentation/providers/song/repertoire_provider.dart';
import 'package:cancioneroruah/domain/entities/song/repertoire.dart';



class RepertoireNotifier extends StateNotifier<List<Repertoire>> {

  final RepertoireRepository repository;
  final SongRepository songRepository;

  RepertoireNotifier(this.repository, this.songRepository) : super([]);


  Future<Repertoire> getRepertoireById(String repertoireId) async {
     return await repository.getRepertoireById(repertoireId);
  }

  Future<void> loadRepertoires(String userId) async {
    final repertoires = await repository.getUserRepertoires(userId);
    state = repertoires;
    //return repertoires;
  }

  // Future<List<Song>> loadRepertoireSongs(String repertoireId) async {
  //   final repertoire = state.firstWhere((r) => r.id == repertoireId);
  //   final songIds = repertoire.songIds;
  //   final songs = await Future.wait(songIds.map((id) => songRepository.getSongById(id)));
  //   return songs; 
  // }


  Future<void> loadRepertoireById(String id) async {
    final repertoire = await repository.getRepertoireById(id);
    state = [repertoire]; // Actualiza el estado con el repertorio recuperado
  }


  Future<void> addRepertoire(Repertoire repertoire, String userId) async {
      await repository.addRepertoire(repertoire);
      state = [...state, repertoire];
      await loadRepertoires(repertoire.userId);
  }

  Future<void> deleteRepertoire(String repertoireId) async {
     await repository.deleteRepertoire(repertoireId);
    state = state.where((repertoire) => repertoire.id != repertoireId).toList();
  }

  Future<void> updateRepertoire(String repertoireId, List<String> songIds) async {
    await repository.updateRepertoire(repertoireId, songIds);
    final repertoire = state.where((repertoire) => repertoire.id != repertoireId).first;
    await loadRepertoires(repertoire.userId);
  }

  Future<void> updateSongOrder(String repertoireId, List<String> newOrder) async {
    await repository.updateSongOrder(repertoireId, newOrder);
    final updatedRepertoire = await repository.getRepertoireById(repertoireId);
    state = state.map((repertoire) {
        if (repertoire.id == repertoireId) {
          return updatedRepertoire;
        }
        return repertoire;
      }).toList();
  }

  Future<void> removeSongFromRepertoire(String repertoireId, String songId) async {
    await repository.removeSongFromRepertoire(repertoireId, songId);
    state = state.map((repertoire){
      if(repertoire.id == repertoireId){
        return repertoire.copyWith(
          songIds: repertoire.songIds.where((id) => id != songId).toList(),
        );
        
      }
      return repertoire;
    }).toList();
  }


  Future<void> updateRepertoireTitle(String repertoireId, String newTitle) async {
    await repository.updateRepertoireTitle(repertoireId, newTitle);
    // Actualiza la lista de repertorios después de la actualización
    final repertoire = state.where((repertoire) => repertoire.id != repertoireId).first;
    await loadRepertoires(repertoire.userId);
  }
  
}

final repertoireNotifierProvider = StateNotifierProvider<RepertoireNotifier, List<Repertoire>>((ref){
  final repository = ref.read(repertoireRepositoryProvider);
  final songRepository = ref.read(songRepositoryProvider);
  return RepertoireNotifier(repository, songRepository);
});
