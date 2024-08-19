import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancioneroruah/presentation/providers/providers.dart';


class ThemeChangerScreen extends ConsumerWidget {

  static const String name = 'theme_changer_screen';

  const ThemeChangerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isDarkmode = ref.watch( themeNotifierProvider ).isDarkmode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Changer'),
        actions: [
          IconButton(
            icon: Icon(isDarkmode ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
            onPressed: (){
              // ref.read(isDakmodeProvider.notifier).update((state) => !state);
              ref.read( themeNotifierProvider.notifier ).toggleDarkmode();
            }
          )
        ],
      ),
      body: const _ThemeChangerView(),
    );
  }
}

class _ThemeChangerView extends ConsumerWidget {
  const _ThemeChangerView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final List<Color> colors = ref.watch( colorListProvider );

    final int selectedColorIndex = ref.watch( themeNotifierProvider ).selectedColor;
  

    return ListView.builder(
      itemCount: colors.length,
      itemBuilder: (context, index){

        final color = colors[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color
                ),
                child: RadioListTile(
                  title: const Text('Este color', style: TextStyle(color: Colors.white),),
                  subtitle: Text('${color.value}'),
                  activeColor: Colors.white,
                  value: index,
                  groupValue: selectedColorIndex,
                  onChanged: (value){
                    //ref.read(selectedColorProvider.notifier).state = index;
                    ref.read( themeNotifierProvider.notifier ).changeColorIndex(index);
                  }
                ),
              ),
              const SizedBox(height: 20,)
            ],
          ),
        );
      }
    );
  }
}