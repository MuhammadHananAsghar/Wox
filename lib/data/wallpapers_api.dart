import 'dart:async';
import 'package:http/http.dart' as http;

class WallpapersApi {
  Future getWallpapers(query) async {
    String url =
        'https://hdwallpapersbyhanan.herokuapp.com/api/v2?query=$query&page=1&size=48&secret=sultan';
    var response = await http.get(Uri.parse(url));
    return response;
  }
}
