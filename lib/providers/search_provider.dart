import 'package:flutter/material.dart';

class SearchQuery extends ChangeNotifier {
  late String _query = "";

  String get query => _query;

  void setQuery(text) {
    _query = text;
    notifyListeners();
  }
}
