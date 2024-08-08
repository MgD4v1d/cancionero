
class Song {

  final String id;
  final String title;
  final String artist;
  final String lyrics;
  final String? videoUrl;
  // final List<String> chords;
  //final bool isFavorite;
  // final String userId;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.lyrics,
    this.videoUrl,
    // required this.chords,
    //this.isFavorite = false,
    // required this.userId,
  });
}