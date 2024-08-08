import 'package:cancioneroruah/domain/domain.dart';

class Repertoire{

  final String id;
  final String userId; // ID del usuario
  final String name;
  final List<Song> songs;

  Repertoire({
    required this.id,
    required this.userId,
    required this.name,
    required this.songs,
  });

}