
class RepertoireModel {
  final String id;
  final String userId; // ID del usuario
  final String title;
  final List<String> songIds;

  RepertoireModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.songIds,
  });

  factory RepertoireModel.fromMap(Map<String, dynamic> map) {
    return RepertoireModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      songIds: List<String>.from(map['songIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'songIds': songIds,
    };
  }

  RepertoireModel copyWith({
    String? id,
    String? userId,
    String? title,
    List<String>? songIds,
  }) {
    return RepertoireModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      songIds: songIds ?? this.songIds,
    );
  }
}
