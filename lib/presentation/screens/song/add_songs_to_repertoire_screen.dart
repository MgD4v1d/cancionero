import 'package:cancioneroruah/presentation/notifiers/song/repertoire_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cancioneroruah/domain/entities/song/repertoire.dart';
import 'package:cancioneroruah/presentation/providers/providers.dart';
import 'package:cancioneroruah/domain/domain.dart';


class AddSongsToRepertoireScreen extends ConsumerStatefulWidget {

  static const String name = 'add-repertoire';

  final String repertoireTitle;

  const AddSongsToRepertoireScreen({
    super.key,
    required this.repertoireTitle
  });

  @override
  ConsumerState<AddSongsToRepertoireScreen> createState() => _AddSongsToRepertoireScreen();
}

class _AddSongsToRepertoireScreen extends ConsumerState<AddSongsToRepertoireScreen> {

  final List<String> selectedSongIds = [];
  String _repertoireName = '';

  

  @override
  Widget build(BuildContext context) {

    final allSongsAsyncValue = ref.watch(allSongsProvider);
    final titleStyle = Theme.of(context).textTheme.titleSmall;
    final captionStyle = Theme.of(context).textTheme.bodySmall;
    

    _repertoireName = widget.repertoireTitle;

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar a : ${widget.repertoireTitle}'),
      ),

      body: allSongsAsyncValue.when(
        data: (songs){

          List<Song> displayedSongs = List.from(songs);

          return ListView.builder(
            itemCount: displayedSongs.length,
            itemBuilder: (context, index) {

              final song = songs[index];
              final isSelected = selectedSongIds.contains(song.id);

              return ListTile(
                title: Text(song.title, style: titleStyle,),
                subtitle: Text(song.artist, style: captionStyle,),
                trailing: IconButton(
                  icon: Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank),
                  onPressed: (){
                    setState(() {  
                      if(isSelected){
                        selectedSongIds.remove(song.id);
                      }else{
                        selectedSongIds.add(song.id);
                      }
                    });
                  },
                ),
              );
              
            },
          );

        }, 
        loading: () => const Center(child: CircularProgressIndicator()), 
        error: (error, stack) => Center(child: Text('Errors: $error')),
      ),

      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.save),
          label: const Text('Guardar esquema'),
          onPressed: _saveRepertoire
        ),
    );
  }
    
    
    void _saveRepertoire() async {

        final user = ref.watch(authChangeNotifierProvider).user;
        final userId = user!.id;
        final newRepertoire = Repertoire(
          id: '', 
          title: _repertoireName, 
          userId: userId, 
          songIds: selectedSongIds
        );

        //ref.read(repertoireRepositoryProvider).addRepertoire(newRepertoire);
        ref.read(repertoireNotifierProvider.notifier).addRepertoire(newRepertoire, userId);

        Navigator.of(context).pop('/home/repertories');
    }


}


