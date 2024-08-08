import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeGridItem extends ConsumerWidget {
  final IconData icon;
  final String label;
  final int? count;
  final VoidCallback onTap;

  const HomeGridItem(
      {super.key,
      required this.icon,
      required this.label,
      this.count,
      required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Icon(icon, size: 50, color: colors.primary),
            Text(label,
                textAlign: TextAlign.center, style: GoogleFonts.robotoMono()),
            const Padding(padding: EdgeInsets.all(6)),
            if (count != null)
              CircleAvatar(
                  child: Text(
                '$count',
                style: const TextStyle(fontSize: 10),
              )),
          ],
        ),
      ),
    );
  }
}
