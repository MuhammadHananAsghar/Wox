// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  // Full Page Add
  late InterstitialAd? _interstitialAd;
  bool _isAddLoaded = false;

  // For Loading Ad
  void _initAd() {
    InterstitialAd.load(
        adUnitId: InterstitialAd.testAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: onAdLoaded,
          onAdFailedToLoad: (error) {},
        ));
  }

  void onAdLoaded(InterstitialAd ad) {
    _interstitialAd = ad;
    _isAddLoaded = true;
  }

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

  // ignore: unused_local_variable
  var wallpapers = [];

  _getWallpapers() {
    String qry = context.watch<SearchQuery>().query;
    retreiveWallpapers(qry);
    setState(() {
      wallpapers = context.watch<WallViewProvider>().queryWallpapers;
    });
  }

  @override
  void initState() {
    super.initState();
    // _initAd();
    setState(() {
      flag = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getWallpapers();
    return Container(
      child: flag && wallpapers.length - 1 > 0
          ? Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "${wallpapers.length} wallpapers available",
                    style: TextStyle(
                        fontSize: 14, color: Colors.black87.withOpacity(0.6)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GridView.builder(
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
                    return wallCard(wallpapers[index].image,
                        wallpapers[index].id, idGenerator());
                  },
                ),
              ],
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Center(
                child: notFound
                    ? Text(
                        'Wallpapers not found.',
                        style: TextStyle(
                            fontFamily: 'Euclid',
                            fontSize: 20,
                            color: Colors.grey.withOpacity(0.7),
                            fontWeight: FontWeight.bold),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                            width: 30,
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Please wait your internet is slow.',
                            style: TextStyle(
                                fontFamily: 'Euclid',
                                fontSize: 15,
                                color: Colors.grey.withOpacity(0.7),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
              ),
            ),
    );
  }

  Widget wallCard(image, wallpaperID, uniqueID) {
    return GestureDetector(
      onTap: () {
        // Showing Add on Click Event
        // if (_isAddLoaded) {
        //   _interstitialAd?.show();
        // }
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
