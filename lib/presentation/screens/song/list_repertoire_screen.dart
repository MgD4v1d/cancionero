import 'package:cancioneroruah/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cancioneroruah/presentation/notifiers/song/repertoire_notifier.dart';
import 'package:cancioneroruah/domain/domain.dart';
import 'package:cancioneroruah/domain/entities/song/repertoire.dart';
import 'package:google_fonts/google_fonts.dart';



class ListRepertoireScreen extends ConsumerWidget {
    static const String name = 'list-repertoire-screen';
    final Repertoire repertoire;
    
    
    const ListRepertoireScreen({
      super.key,
      required this.repertoire
    });
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final repertoireNotifier = ref.watch(repertoireNotifierProvider.notifier);
    ref.watch(repertoireNotifierProvider);
    final captionStyle = Theme.of(context).textTheme.bodySmall;

    return Scaffold(
      appBar: AppBar(
        title: Text(repertoire.title),
      ),

      body: FutureBuilder<List<Song>>(
        future: repertoireNotifier.loadRepertoireSongs(repertoire.id), 
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasError){
            return const Center(child: Text('Error loading songs'));
          }else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text('No songs found'));
          }

          final songs = snapshot.data!;

          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                trailing: PopupMenuButton<String>(
                  onSelected: (String value){
                    if(value == 'delete'){
                      _showDialogMessageDelete(context, ref, repertoire, song);
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
                title: Text(song.title, style: GoogleFonts.robotoMono(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),),
                subtitle: Text(song.artist, style: captionStyle,),
                onTap: () {
                  // Aquí puedes agregar la navegación a una pantalla de detalles de la canción
                  context.push('/home/repertories/repertoire-detail/repertoire-song-detail', extra: song);
                },
              );
            },
          );
        }
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Agregar canciones al esquema'),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddSongsToRepertoireScreen(
                repertoireTitle: repertoire.title,
              ),
            ),
          );
        },
      ),
    );
  }
}


_showDialogMessageDelete(BuildContext context, WidgetRef ref, Repertoire repertoire, Song song) {

  return showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Eliminar canción del esquema'),
        content: const Text('¿Estás seguro de que quieres eliminar esta canción del esquema?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: const Text('Cancelar')
          ),
          TextButton(
            onPressed: () {
              ref.read(repertoireNotifierProvider.notifier).removeSongFromRepertoire(
                repertoire.id,
                song.id,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      );
    }
  );
}