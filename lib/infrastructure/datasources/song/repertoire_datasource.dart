import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cancioneroruah/infrastructure/models/repertoire_model.dart';

class RepertoireDatasource {

  final FirebaseFirestore firestore;

  RepertoireDatasource(this.firestore);


  Future<RepertoireModel> getRepertoireById(String id) async {
    final doc = await firestore.collection('repertoires').doc(id).get();

    if (!doc.exists) {
      throw Exception('Repertoire with id $id does not exist');
    }

    final data = doc.data();

    if (data == null) {
      throw Exception('No data found for repertoire with id $id');
    }
    return RepertoireModel.fromMap({
        'id': doc.id,
        ...data,
    });
  }

  Future<List<RepertoireModel>> getUserRepertoires(String userId) async {

    final snapshot = await firestore
        .collection('repertoires')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc){
      var data = doc.data();
      return RepertoireModel.fromMap({
        'id' : doc.id,
        ...data,
      });
    }).toList();
  }

  Future<String> addRepertoire(RepertoireModel repertoire) async {
    final docRef = await firestore.collection('repertoires').add(repertoire.toMap());
    return docRef.id;    
  }

  Future<void> updateRepertoire(String repertoreId, RepertoireModel repertoire) async {
    await firestore.collection('repertoires').doc(repertoreId).update(repertoire.toMap());
  }

  Future<void> updateSongsToRepertoire(String repertoreId, List<String> songIds) async {
    await firestore.collection('repertoires').doc(repertoreId).update({
      'songIds': songIds,
    });
  }

  Future<void> updateSongOrder(String repertoireId, List<String> newOrder) async {
    await firestore.collection('repertoires').doc(repertoireId).update({
      'songIds': newOrder,
    });
  }

  Future<void> deleteRepertoire(String repertoireId) async {
    await firestore.collection('repertoires').doc(repertoireId).delete();
  }

  Future<void> removeSongFromRepertoire(String repertoireId, String songId) async {
    final docRef = firestore.collection('repertoires').doc(repertoireId);
    final doc = await docRef.get();

    if(doc.exists){
      final data = doc.data()!;
      final songIds = List<String>.from(data['songIds'] ?? []);
      songIds.remove(songId);
      await docRef.update({'songIds': songIds});
    }
  }

  Future<void> updateRepertoireTitle(String repertoireId, String newTitle) async {
    await firestore.collection('repertoires').doc(repertoireId).update({
      'title': newTitle,
    });
  }

}