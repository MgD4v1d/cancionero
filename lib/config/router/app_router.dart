import 'package:cancioneroruah/domain/domain.dart';
import 'package:cancioneroruah/domain/entities/song/repertoire.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cancioneroruah/presentation/screens/screens.dart';
import 'package:cancioneroruah/presentation/providers/providers.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = Provider<GoRouter>((ref) {

  final authNotifier = ref.watch(authChangeNotifierProvider);

  return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      refreshListenable: authNotifier,
      redirect: (context, state) {

        final user = authNotifier.user;

        // Define whether the user is logged in
        final isLoggingIn = state.uri.toString() == '/';

        if(user == null){
          return isLoggingIn ? null : '/';
        }

        if(isLoggingIn){
          return '/home';
        }

        // No need to redirect at all.
        return null;

      },
      routes: [
        GoRoute(
          path: '/',
          name: LoginScreen.name,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/home',
          name: HomeScreen.name,
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'all-songs',
              name: AllSongsScreen.name,
              builder: (context, state) => const AllSongsScreen(),
              routes: [
                GoRoute(
                  path: 'song-detail',
                  name: SongDetailScreen.name,
                  builder: (context, state) {
                    final song = state.extra as Song;

                    return SongDetailScreen(song: song);
                  },
                ),
              ],
            ),

            GoRoute(
              path: 'repertories',
              name: RepertorieScreen.name,
              builder: (context, state) =>  const RepertorieScreen(),
              routes: [
                GoRoute(
                  path: 'repertoire-detail',
                  name: ListRepertoireScreen.name,
                  builder: (context, state) {
                    final repertoire = state.extra as Repertoire;
                    return ListRepertoireScreen(repertoire: repertoire);
                  },
                  routes: [
                    GoRoute(
                      path: 'repertoire-song-detail',
                      name: RepertoireSongDetailScreen.name,
                      builder: (context, state) {
                        final song = state.extra as Song;

                        return RepertoireSongDetailScreen(song: song);
                      },
                    ),
                  ]
                ),

                
              ]
            ),

            GoRoute(
              path: 'add-repertoire',
              name: AddSongsToRepertoireScreen.name,
              builder: (context, state) {
                final repertoire = state.extra as Repertoire;
                return AddSongsToRepertoireScreen(repertoire: repertoire);
              },
            ),

            
          ]
        ),
      ]);
});
