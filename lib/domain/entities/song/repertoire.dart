class Repertoire{
  final String id;
  final String userId; // ID del usuario
  final String title;
  final List<String> songIds;

  Repertoire({
    required this.id,
    required this.userId,
    required this.title,
    required this.songIds,
  });


  Repertoire copyWith({
    String? id,
    String? userId,
    String? title,
    List<String>? songIds,
  }){
    return Repertoire(
      id: id ?? this.id, 
      userId: userId ?? this.userId, 
      title: title ?? this.title, 
      songIds: songIds ?? this.songIds
    );
  }

}