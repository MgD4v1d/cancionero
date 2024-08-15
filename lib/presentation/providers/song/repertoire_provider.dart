import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

//import 'package:cancioneroruah/presentation/notifiers/song/repertoire_notifier.dart';
//import 'package:cancioneroruah/domain/entities/song/repertoire.dart';
import 'package:cancioneroruah/domain/repositories/song/repertoire_repository.dart';
import 'package:cancioneroruah/infrastructure/infrastructure.dart';


final repertoireDataSourceProvider = Provider<RepertoireDatasource>((ref) {
  final firestore = FirebaseFirestore.instance;
  return RepertoireDatasource(firestore);
});


final repertoireRepositoryProvider = Provider<RepertoireRepository>((ref) {
  final dataSource = ref.read(repertoireDataSourceProvider);
  return RepertoireRepositoryImpl(dataSource);
});



// final authStateProvider = StreamProvider<User?>((ref) {
//    return FirebaseAuth.instance.authStateChanges();
// });



// final repertoireNotifierProvider = StateNotifierProvider.autoDispose.family<RepertoireNotifier, List<Repertoire>, String>((ref, userId) {
//   final repository = ref.watch(repertoireRepositoryProvider);
//   return RepertoireNotifier(repository)..loadRepertoires(userId);
// });


// final repertoiresProvider = FutureProvider<List<Repertoire>>((ref) async {
//   final authState = ref.watch(authStateProvider).asData?.value;
//   if (authState == null) {
//     return [];
//   }
//   final repertoireRepository = ref.read(repertoireRepositoryProvider);
//   return await repertoireRepository.getUserRepertoires(authState.uid);
// });

