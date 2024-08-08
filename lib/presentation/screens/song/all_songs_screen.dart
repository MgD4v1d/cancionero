import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cancioneroruah/domain/entities/song/song.dart';
import 'package:cancioneroruah/presentation/providers/providers.dart';

class AllSongsScreen extends ConsumerStatefulWidget {
  static const String name = 'all-song-screen';

  const AllSongsScreen({super.key});

  @override
  ConsumerState<AllSongsScreen> createState() => _AllSongsScreen();
}

class _AllSongsScreen extends ConsumerState<AllSongsScreen> {
  bool _isSortedAZ = false;
  bool _isSearching = false;
  String _searchQuery = '';

  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  void _toggleSortOrder() {
    setState(() {
      _isSortedAZ = !_isSortedAZ;
    });
  }

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
  Widget build(BuildContext context) {
    final allSongsAsyncValue = ref.watch(allSongsProvider);
    final titleStyle = Theme.of(context).textTheme.titleSmall;
    final captionStyle = Theme.of(context).textTheme.bodySmall;

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
                : const Text('Lista de Canciones'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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

              PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'sortAZ') {
                    allSongsAsyncValue.whenData((songs) {
                      _toggleSortOrder();
                    });
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'sortAZ',
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.sort_outlined),
                        ),
                        Text('Ordenar'),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
        body: allSongsAsyncValue.when(
          data: (songs) {
            List<Song> displayedSongs = List.from(songs);

            if (_isSortedAZ) {
              displayedSongs.sort((a, b) => a.title.compareTo(b.title));
            }

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

                return ListTile(
                  leading: const CircleAvatar(
                      child: Text(
                    'Text',
                    style: TextStyle(fontSize: 10),
                  )),
                  title: Text(
                    song.title,
                    style: titleStyle,
                  ),
                  subtitle: Text(
                    song.artist,
                    style: captionStyle,
                  ),
                  onTap: () {
                    // Navigate to song details or perform another action
                    context.go('/home/all-songs/${song.id}');
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Errors: $error')),
        ));
  }
}
