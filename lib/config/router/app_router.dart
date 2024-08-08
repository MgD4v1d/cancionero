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
                  path: ':songId',
                  name: SongDetailScreen.name,
                  builder: (context, state) {
                    final songId = state.pathParameters['songId']!;
                    return SongDetailScreen(songId: songId);
                  },
                ),
            ],
            ),

            GoRoute(
              path: 'repertories',
              name: RepertorieScreen.name,
              builder: (context, state) =>  const RepertorieScreen(),
            ),
          ]
        ),
      ]);
});
