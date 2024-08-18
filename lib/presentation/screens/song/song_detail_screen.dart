import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cancioneroruah/domain/domain.dart';
import 'package:cancioneroruah/presentation/providers/providers.dart';

class SongDetailScreen extends ConsumerWidget {
  static const String name = 'song-detail-screen';

  final Song song;

  const SongDetailScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final songAsyncValue = ref.watch(songProvider(song.id));
    final textSize = ref.watch(textSizeProvider);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: songAsyncValue.when(
            data: (song) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(song.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(song.artist, style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey)),
              ],
            ), 
            loading: () => const Text('Cargando....'),
            error: (error, stack) => const Text('Error'),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                  onPressed: () =>
                      {ref.read(textSizeProvider.notifier).increaseTextSize()},
                  icon: const Icon(Icons.text_increase)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                  onPressed: () =>
                      {ref.read(textSizeProvider.notifier).decreaseTextSize()},
                  icon: const Icon(Icons.text_decrease)),
            ),
          ],
        ),
        body: songAsyncValue.when(
          data: (song) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    song.lyrics.replaceAll('\\n', '\n'),
                    style: GoogleFonts.robotoMono(
                      fontSize: textSize
                    )       
                  ),

                  
                  if (song.videoUrl != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Video:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  
                  TextButton.icon(
                    onPressed: (){},
                    icon: const Icon(Icons.smart_display, size: 40,),  
                    label: Text(
                      song.title,
                      style: const TextStyle(fontSize: 16),
                    )
                  ),

                ],

                ],
              ),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator()
          ),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ));
  }


  Future<void> _launchYouTube(String? videoUrl) async {
  final Uri url = Uri.parse(videoUrl!);

      // Verifica si la URL se puede lanzar
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication
        );
      } else {
        throw 'No se puede abrir la URL: $url';
      }
  }
}
