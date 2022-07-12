import 'dart:async';
import 'package:http/http.dart' as http;

class WallpapersApi {
  Future getWallpapers(query) async {
    query = query.toString().toLowerCase();
    String url =
        'https://hdwallpapersbyhanan.herokuapp.com/api/v3?query=$query';
    var response = await http.get(Uri.parse(url));
    return response;
  }
}
