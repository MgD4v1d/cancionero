import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cancioneroruah/presentation/providers/song/song_provider.dart';
import 'package:cancioneroruah/presentation/screens/screens.dart';
import 'package:cancioneroruah/presentation/notifiers/song/repertoire_notifier.dart';
import 'package:cancioneroruah/domain/domain.dart';
import 'package:cancioneroruah/domain/entities/song/repertoire.dart';

class SelectedRepertoireScreen extends ConsumerWidget {
  static const String name = 'selected-repertoire-screen';
  final Repertoire repertoire;

  const SelectedRepertoireScreen({
    super.key,
    required this.repertoire,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repertoireNotifier = ref.watch(repertoireNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(repertoire.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'share') {}
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.share),
                    ),
                    Text('Compartir esquema'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final repertoireState = ref.watch(repertoireNotifierProvider);

          // Find the current repertoire from the state
          final currentRepertoire = repertoireState.firstWhere(
            (rep) => rep.id == repertoire.id,
            orElse: () => repertoire,
          );

          return FutureBuilder<List<Song>>(
            future: Future.wait(
              currentRepertoire.songIds.map(
                  (id) => ref.read(songRepositoryProvider).getSongById(id)),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('Error al cargar las canciones.'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                    child: Text(
                  'No tienes canciones agregadas al esquema.',
                  style: GoogleFonts.robotoMono(fontSize: 16),
                ));
              }

              final songs = snapshot.data!;
              final orderedSongs = currentRepertoire.songIds
                  .map((id) => songs.firstWhere((song) => song.id == id))
                  .toList();

              return FadeIn(
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) async {
                    if (newIndex > oldIndex) newIndex--;
                    final song = orderedSongs.removeAt(oldIndex);
                    orderedSongs.insert(newIndex, song);

                    await repertoireNotifier.updateSongOrder(
                      repertoire.id,
                      orderedSongs.map((song) => song.id).toList(),
                    );
                  },
                  children: [
                    for (final song in orderedSongs)
                      Card(
                        key: ValueKey(song.id),
                        child: ListTile(
                          leading:
                              const CircleAvatar(child: Icon(Icons.lyrics)),
                          trailing: PopupMenuButton<String>(
                            onSelected: (String value) {
                              if (value == 'delete') {
                                _showDialogMessageDelete(
                                    context, ref, repertoire, song);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.delete),
                                    ),
                                    Text('Eliminar'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            song.title,
                            style: GoogleFonts.robotoMono(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            song.artist,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          onTap: () {
                            context.push(
                                '/home/repertories/repertoire-detail/repertoire-song-detail',
                                extra: song);
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.playlist_add),
        label: const Text('Agregar canciones al esquema'),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddSongsToRepertoireScreen(
                repertoire: repertoire,
              ),
            ),
          );
        },
      ),
    );
  }

  _showDialogMessageDelete(
      BuildContext context, WidgetRef ref, Repertoire repertoire, Song song) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar canción del esquema'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar esta canción del esquema?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await ref
                    .read(repertoireNotifierProvider.notifier)
                    .removeSongFromRepertoire(
                      repertoire.id,
                      song.id,
                    );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
