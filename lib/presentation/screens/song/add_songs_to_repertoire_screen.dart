import 'package:cancioneroruah/presentation/notifiers/song/repertoire_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cancioneroruah/domain/entities/song/repertoire.dart';
import 'package:cancioneroruah/presentation/providers/providers.dart';
import 'package:cancioneroruah/domain/domain.dart';


class AddSongsToRepertoireScreen extends ConsumerStatefulWidget {

  static const String name = 'add-repertoire';

  final Repertoire? repertoire;

  const AddSongsToRepertoireScreen({
    super.key,
    required this.repertoire
  });

  @override
  ConsumerState<AddSongsToRepertoireScreen> createState() => _AddSongsToRepertoireScreen();
}

class _AddSongsToRepertoireScreen extends ConsumerState<AddSongsToRepertoireScreen> {

  final List<String> selectedSongIds = [];
  bool _isSearching = false;
  String _searchQuery = '';

  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();


  void _startSearch() {
    setState(() {
      _isSearching = true;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
    });
    _searchFocusNode.unfocus();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }
  
  @override
  void initState() {
    super.initState();
    if(widget.repertoire != null){
      selectedSongIds.addAll(widget.repertoire!.songIds);
    }
  }

  

  @override
  Widget build(BuildContext context) {

    final allSongsAsyncValue = ref.watch(allSongsProvider);
    final titleStyle = Theme.of(context).textTheme.titleSmall;
    final captionStyle = Theme.of(context).textTheme.bodySmall;
    ref.watch(repertoireNotifierProvider);
    
    

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
          ? TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _updateSearchQuery,
              decoration: const InputDecoration(
                hintText: 'Buscar...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              style: const TextStyle(color: Colors.black),
            )
          : Text('Agregar a : ${widget.repertoire?.title}'),
        
         actions: [
            (_isSearching)
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _stopSearch,
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _startSearch,
                ),
         ]
      ),

      body: allSongsAsyncValue.when(
        data: (songs){

          List<Song> displayedSongs = List.from(songs);

           if (_searchQuery.isNotEmpty) {
              displayedSongs = displayedSongs.where((song){
                return song.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                     song.artist.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                     song.lyrics.toLowerCase().contains(_searchQuery.toLowerCase());
              }).toList();
            }

          return ListView.builder(
            itemCount: displayedSongs.length,
            itemBuilder: (context, index) {

              final song = displayedSongs[index];
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

        if (widget.repertoire!.id == "") {
          final newRepertoire = Repertoire(
            id: '', 
            title: widget.repertoire!.title, 
            userId: userId, 
            songIds: selectedSongIds
          );
          //ref.read(repertoireRepositoryProvider).addRepertoire(newRepertoire);
          ref.read(repertoireNotifierProvider.notifier).addRepertoire(newRepertoire, userId);
          Navigator.of(context).pop('/home/repertories');
        }else{
          ref.read(repertoireNotifierProvider.notifier).updateRepertoire(widget.repertoire!.id, selectedSongIds);
          Navigator.pop(context);
        }

    }


}


