import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancioneroruah/config/config.dart';

// Listado de colores inmutable
final colorListProvider = Provider((ref) => colorList);

// un simple boolean
final isDakmodeProvider = StateProvider<bool>((ref) => false);

// un simple int
final selectedColorProvider = StateProvider<int>((ref) => 0);


// Un objeto de tipo AppTheme (custom)
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>(
  (ref) => ThemeNotifier(),
);

// Controller o Notifier
class ThemeNotifier extends StateNotifier<AppTheme> {

  // creando una instacia del AppTheme  STATE = new AppTheme()
  ThemeNotifier(): super( AppTheme() );

  void toggleDarkmode(){
    state = state.copyWith(isDarkmode: !state.isDarkmode);
  }

  void changeColorIndex(int colorIndex){
    state = state.copyWith(selectedColor: colorIndex);
  }

}