import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cancioneroruah/infrastructure/models/repertoire_model.dart';

class RepertoireDatasource {

  final FirebaseFirestore firestore;

  RepertoireDatasource(this.firestore);

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

  Future<void> addRepertoire(RepertoireModel repertoire) async {
    await firestore.collection('repertoires').add(repertoire.toMap());
  }

  Future<void> updateRepertoire(RepertoireModel repertoire) async {
    await firestore.collection('repertoires').doc(repertoire.id).update(repertoire.toMap());
  }

  Future<void> deleteRepertoire(String id) async {
    await firestore.collection('repertoires').doc(id).delete();
  }

}