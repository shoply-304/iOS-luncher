import 'package:flutter/material.dart';

class WallpaperService {
  static BoxDecoration decoration({bool dark = true}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: dark
            ? const [Color(0xFF15171C), Color(0xFF07080A)]
            : const [Color(0xFFF6F7FA), Color(0xFFDDE3EA)],
      ),
    );
  }
}
