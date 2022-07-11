import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wox/data/wallpapers_api.dart';
import 'package:wox/models/wallpapers_model.dart';
import 'package:wox/providers/search_provider.dart';
import 'package:wox/providers/wallpaper_provider.dart';
import 'package:wox/providers/wallview_provider.dart';
import 'package:wox/screens/wallpaper.dart';

class Grid extends StatefulWidget {
  const Grid({Key? key}) : super(key: key);

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  List<WallpapersModel> wallpapersList = [];
  bool flag = false;
  bool notFound = false;

  void retreiveWallpapers(query) {
    WallpapersApi().getWallpapers('$query').then((response) => {
          if (mounted)
            {
              setState(() {
                flag = true;
                Iterable list = json.decode(response.body);
                wallpapersList = list
                    .map((model) => WallpapersModel.fromJson(model))
                    .toList();

                if (wallpapersList.length <= 1) {
                  setState(() {
                    notFound = true;
                  });
                } else {
                  setState(() {
                    notFound = false;
                  });
                }

                context
                    .read<WallViewProvider>()
                    .setQueryWallpapers(wallpapersList);
              })
            }
        });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      flag = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String qry = context.watch<SearchQuery>().query;
    // ignore: unused_local_variable
    var wallpapers = [];
    retreiveWallpapers(qry);
    wallpapers = context.watch<WallViewProvider>().queryWallpapers;
    return Container(
      child: flag && wallpapers.length - 1 > 0
          ? GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: .6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: wallpapers.length - 1,
              itemBuilder: (context, index) {
                return wallCard(wallpapers[index].image, wallpapers[index].id,
                    idGenerator());
              },
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Center(
                child: Text(
                  notFound ? 'Wallpapers not found.' : 'Loading...',
                  style: TextStyle(
                      fontFamily: 'Euclid',
                      fontSize: 20,
                      color: Colors.grey.withOpacity(0.7),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }

  Widget wallCard(image, wallpaperID, uniqueID) {
    return GestureDetector(
      onTap: () {
        context.read<WallpaperProvider>().setWallpaper(image);
        context.read<WallpaperProvider>().setWallpaperUUID(wallpaperID);
        context.read<WallpaperProvider>().setUniqueID(uniqueID);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Wallpaper()));
      },
      child: Hero(
        tag: uniqueID,
        child: Container(
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
              child: Center(
                child: Text(
                  'wox',
                  style: TextStyle(
                      fontFamily: 'Euclid',
                      fontWeight: FontWeight.bold,
                      fontSize: 33,
                      color: Colors.grey.withOpacity(0.7),
                      decoration: TextDecoration.none),
                ),
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
                  'wox',
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
    );
  }
}