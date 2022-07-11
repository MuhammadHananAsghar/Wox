import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wox/providers/wallview_provider.dart';
import 'package:wox/providers/search_provider.dart';
import 'package:wox/providers/wallpaper_provider.dart';
import 'package:wox/screens/splash.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SearchQuery()),
      ChangeNotifierProvider(create: (_) => WallpaperProvider()),
      ChangeNotifierProvider(create: (_) => WallViewProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Splash(),
      theme: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          fontFamily: 'Euclid',
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Color(0xFF4063F3))),
    ),
  ));
}
