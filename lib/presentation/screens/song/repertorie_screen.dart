import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class RepertorieScreen extends ConsumerWidget {

  static const String name = 'repertorie-screen';

  const RepertorieScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis esquemas'),
      ),

      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
              child: Text('No tienes un esquema agregado. \n Para agregar un "Esquema" pulsa el icono de más abajo', 
              textAlign: TextAlign.center,
              style: GoogleFonts.robotoMono(
                fontWeight: FontWeight.bold
              )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
        },
      ),
    );
  }
}