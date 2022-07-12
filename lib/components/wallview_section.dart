import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:wox/data/wallpapers_api.dart';
import 'package:wox/models/wallpapers_model.dart';
import 'package:wox/providers/wallview_provider.dart';
import 'package:wox/providers/search_provider.dart';
import 'package:wox/providers/wallpaper_provider.dart';
import 'package:wox/screens/search.dart';
import 'package:wox/screens/wallpaper.dart';

class WallView extends StatefulWidget {
  final String heading;
  const WallView({Key? key, required this.heading}) : super(key: key);

  @override
  State<WallView> createState() => _WallViewState();
}

class _WallViewState extends State<WallView> {
  List<WallpapersModel> wallpapersList = [];
  String url = '';
  // Getting Wallpapers
  void retreiveWallpapers(query) async {
    WallpapersApi().getWallpapers('$query').then((response) => {
          setState(() {
            Iterable list = json.decode(response.body);
            wallpapersList =
                list.map((model) => WallpapersModel.fromJson(model)).toList();
            if (query == 'Mountains') {
              context.read<WallViewProvider>().setMoutains(wallpapersList);
            } else if (query == 'Cars') {
              context.read<WallViewProvider>().setCars(wallpapersList);
            } else if (query == 'Attitude') {
              context.read<WallViewProvider>().setAttitude(wallpapersList);
            } else {
              context.read<WallViewProvider>().setSea(wallpapersList);
            }
          })
        });
  }

  @override
  void initState() {
    super.initState();
    retreiveWallpapers(widget.heading);
  }

  void _navigate(to) {
    context.read<SearchQuery>().setQuery(to);
    Navigator.of(context).push(_createRoute(const Search()));
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  @override
  Widget build(BuildContext context) {
    var wallpapers = [];
    if (widget.heading == 'Mountains') {
      wallpapers = context.watch<WallViewProvider>().mountainsWallpapers;
    } else if (widget.heading == 'Cars') {
      wallpapers = context.watch<WallViewProvider>().carsWallpapers;
    } else if (widget.heading == 'Attitude') {
      wallpapers = context.watch<WallViewProvider>().attitudeWallpapers;
    } else {
      wallpapers = context.watch<WallViewProvider>().seaWallpapers;
    }
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.heading,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              InkWell(
                onTap: () {
                  _navigate(widget.heading);
                },
                child: const Text(
                  "See all",
                  style: TextStyle(color: Color(0xFF4063F3), fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
              height: 250,
              child: wallpapers.length - 1 > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return paper(wallpapers[index].image,
                            wallpapers[index].id, idGenerator());
                      },
                      scrollDirection: Axis.horizontal)
                  : const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    )),
        ],
      ),
    );
  }

  Widget paper(image, wallpaperID, uniqueID) {
    return SizedBox(
      width: 155,
      child: Stack(
        children: [
          Hero(
            tag: uniqueID,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.only(right: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: image,
                placeholder: (context, url) => Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'wox',
                        style: TextStyle(
                            fontFamily: 'Euclid',
                            fontWeight: FontWeight.bold,
                            fontSize: 33,
                            color: Colors.grey.withOpacity(0.7),
                            decoration: TextDecoration.none),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 15,
                        width: 15,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Text(
                      'error',
                      style: TextStyle(
                          fontFamily: 'Euclid',
                          fontWeight: FontWeight.bold,
                          fontSize: 33,
                          color: Colors.red.withOpacity(0.7),
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 7,
              right: 15,
              child: GestureDetector(
                onTap: () {
                  context.read<WallpaperProvider>().setWallpaper(image);
                  context
                      .read<WallpaperProvider>()
                      .setWallpaperUUID(wallpaperID);
                  context.read<WallpaperProvider>().setUniqueID(uniqueID);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Wallpaper()));
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.black87,
                    size: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

Route _createRoute(route) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => route,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
