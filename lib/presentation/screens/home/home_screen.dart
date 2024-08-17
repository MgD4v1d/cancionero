import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cancioneroruah/presentation/providers/song/song_provider.dart';
import 'package:cancioneroruah/presentation/widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String name = 'home-screen';

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final songCountAsyncValue = ref.watch(songsCountProvider);

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text('Cancionero Ruah'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allSongsProvider);
        },
        strokeWidth: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(crossAxisCount: 2, children: [

            songCountAsyncValue.when(
              data: (countSongs) {
                return HomeGridItem(
                  icon: Icons.library_music,
                  count: countSongs,
                  label: 'Lista de canciones',
                  onTap: () => context.go('/home/all-songs'),
                );
              },
              loading: () => const Center(child: Text('Cargando...'),),
              error: (error, stack) => Center(child: Text('Errors: $error')),
            ),


            HomeGridItem(
              icon: Icons.queue_music,
              label: 'Mis Esquemas',
              onTap: () => context.go('/home/repertories'),
            ),


          ]),
        ),
      ),
    );
  }
}
