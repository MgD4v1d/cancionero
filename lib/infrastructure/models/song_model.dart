class SongModel {

  final String id;
  final String title;
  final String artist;
  final String lyrics;
  final String? videoUrl;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.lyrics,
    this.videoUrl,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      lyrics: json['lyrics'],
      videoUrl: json['videoUrl'],
  );
  

  Map<String, dynamic> toJson() => {
      'id': id,
      'title': title,
      'artist': artist,
      'lyrics': lyrics,
      'videoUrl': videoUrl,
    
  };
}
