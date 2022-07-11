import 'package:flutter/material.dart';

class WallpaperProvider extends ChangeNotifier {
  late String _wallpaper = '';
  late String _wallpaperUUID = '';
  late String _uniqueID = '';

  String get wallpaper => _wallpaper;
  String get wallpaperUUID => _wallpaperUUID;
  String get uniqueID => _uniqueID;

  void setWallpaper(url) {
    _wallpaper = url;
    notifyListeners();
  }

  void setWallpaperUUID(id) {
    _wallpaperUUID = id;
    notifyListeners();
  }

  void setUniqueID(id) {
    _uniqueID = id;
    notifyListeners();
  }
}
