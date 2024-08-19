class Repertoire{
  final String id;
  final String title;
  final List<String> songIds;
  final String userId; // ID del usuario

  Repertoire({
    required this.id,
    required this.title,
    required this.songIds,
    required this.userId,
  });


  Repertoire copyWith({
    String? id,
    String? title,
    List<String>? songIds,
    String? userId,
  }){
    return Repertoire(
      id: id ?? this.id, 
      title: title ?? this.title, 
      songIds: songIds ?? this.songIds,
      userId: userId ?? this.userId, 
    );
  }

}