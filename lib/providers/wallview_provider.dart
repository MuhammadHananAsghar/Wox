import 'package:flutter/material.dart';
import 'package:wox/models/wallpapers_model.dart';

class WallViewProvider extends ChangeNotifier {
  List<WallpapersModel> _mountainsWallpapers = [];
  List<WallpapersModel> _carsWallpapers = [];
  List<WallpapersModel> _attitudeWallpapers = [];
  List<WallpapersModel> _seaWallpapers = [];
  List<WallpapersModel> _queryWallpapers = [];

  List get mountainsWallpapers => _mountainsWallpapers;
  List get carsWallpapers => _carsWallpapers;
  List get attitudeWallpapers => _attitudeWallpapers;
  List get seaWallpapers => _seaWallpapers;
  List get queryWallpapers => _queryWallpapers;

  void setMoutains(list) {
    _mountainsWallpapers = list;
    notifyListeners();
  }

  void setCars(list) {
    _carsWallpapers = list;
    notifyListeners();
  }

  void setAttitude(list) {
    _attitudeWallpapers = list;
    notifyListeners();
  }

  void setSea(list) {
    _seaWallpapers = list;
    notifyListeners();
  }

  void setQueryWallpapers(list) {
    _queryWallpapers = list;
    notifyListeners();
  }
}
