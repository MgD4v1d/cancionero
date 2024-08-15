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

  Future<void> loadRepertoires(String userId) async {
    final repertoires = await repository.getUserRepertoires(userId);
    state = repertoires;
    //return repertoires;
  }

  Future<List<Song>> loadRepertoireSongs(String repertoireId) async {
    final repertoire = state.firstWhere((r) => r.id == repertoireId);
    final songIds = repertoire.songIds;
    final songs = await Future.wait(songIds.map((id) => songRepository.getSongById(id)));
    return songs; 
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


}

final repertoireNotifierProvider = StateNotifierProvider<RepertoireNotifier, List<Repertoire>>((ref){
  final repository = ref.read(repertoireRepositoryProvider);
  final songRepository = ref.read(songRepositoryProvider);
  return RepertoireNotifier(repository, songRepository);
});
