import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cancioneroruah/infrastructure/models/song_model.dart';

class SongDatasource {
  
  final FirebaseFirestore firestore;

  SongDatasource(this.firestore);

  Future<List<SongModel>> getAllSongs() async {
    final querySnapshot = await firestore.collection('songs').get();

    return querySnapshot.docs.map((doc){
      final data = doc.data();
      data['id'] = doc.id;
      return SongModel.fromJson(data);
    }).toList();
  }


  Future<SongModel> getSongById(String id) async {
    final docSnapshot = await firestore.collection('songs').doc(id).get();
    if(docSnapshot.exists){

      final data = docSnapshot.data();
      data?['id'] = docSnapshot.id;
      return SongModel.fromJson(data!);
    }else{
      throw Exception('Song not found');
    }
  }


  Future<int> getSongsCount() async {
    final querySnapshot = await firestore.collection('songs').get();
    return querySnapshot.size;
  }

  Future<List<SongModel>> getSongsByIds(List<String> songIds) async {
    final querySnapshot = await firestore
        .collection('songs')
        .where(FieldPath.documentId, whereIn: songIds)
        .get();

    return querySnapshot.docs.map((doc){
      final data = doc.data();
      return SongModel.fromJson(data);
    }).toList();
  }
}