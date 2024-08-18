import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancioneroruah/domain/entities/song/repertoire.dart';
import 'package:cancioneroruah/domain/repositories/song/repertoire_repository.dart';
import 'package:cancioneroruah/presentation/providers/providers.dart';

final repertoireListProvider = StateNotifierProvider<RepertoireListNotifier, List<Repertoire>>((ref) {
  return RepertoireListNotifier(ref.read(repertoireRepositoryProvider));
});

final selectedRepertoirProvider = StateProvider<Repertoire?>((ref)=> null);

class RepertoireListNotifier extends StateNotifier<List<Repertoire>> {
  
  final RepertoireRepository repertoireRepository;

  RepertoireListNotifier(this.repertoireRepository) : super([]);


  Future<void> loadRepertoires(String userId) async {
    state = await repertoireRepository.getRepetoiresById(userId);
  }


}