import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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


