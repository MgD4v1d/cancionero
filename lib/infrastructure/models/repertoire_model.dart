import 'package:cancioneroruah/infrastructure/models/song_model.dart';

class RepertoireModel {
  final String id;
  final String userId; // ID del usuario
  final String name;
  final List<SongModel> songs;

  RepertoireModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.songs,
  });

  factory RepertoireModel.fromMap(Map<String, dynamic> map) {
    return RepertoireModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      songs: (map['songs'] as List<dynamic>?)
              ?.map((songData) =>
                  SongModel.fromMap(songData as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'songs': songs.map((song) => song.toMap()).toList(),
    };
  }
}
