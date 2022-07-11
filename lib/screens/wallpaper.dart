// ignore_for_file: avoid_print, unnecessary_const

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wox/providers/wallpaper_provider.dart';
import 'package:wox/utils/saver.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({Key? key}) : super(key: key);

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  bool loading = false;
  String textValue = "Download";
  static const platform =
      const MethodChannel("com.muhammadhanan.wox/essentials");

  // Function to set wallpaper
  Future<void> setWallpaperFromFile(path, type) async {
    try {
      var result = await platform.invokeMethod("setWallpaper", "$path $type");
      print(result);
    } catch (e) {
      print(e);
    }
  }

  // Bottom Sheet
  _showBottomSheet(String path) {
    showCupertinoModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: true,
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.35,
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: const Text(
                  "Set as wallpaper",
                  style: TextStyle(
                      fontFamily: 'Euclid',
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none),
                ),
              ),
              containerChoice('Home Screen', "home", path),
              containerChoice('Lock Screen', "lock", path),
              containerChoice('Both', "both", path),
            ],
          ),
        ),
      ),
    );
  }

  // Checking if wallpaper already downloaded
  checkAvailable() async {
    String dirPath = await Saver().getDirectory();
    var wallID =
        // ignore: use_build_context_synchronously
        Provider.of<WallpaperProvider>(context, listen: false).wallpaperUUID;
    File file = File('$dirPath/$wallID.jpg');
    if (await file.exists()) {
      setState(() {
        textValue = "Apply";
      });
    } else {
      setState(() {
        textValue = "Download";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkAvailable();
  }

  // Function to download wallpaper
  downloadFile(String wallURL, String wallID) async {
    if (textValue == "Apply") {
      String dirPath = await Saver().getDirectory();
      File file = File('$dirPath/$wallID.jpg');
      _showBottomSheet(file.path.toString());
      return;
    }
    setState(() {
      loading = true;
    });
    if (textValue == "Download") {
      String downloaded = await Saver().saveFile(wallURL, wallID);
      if (downloaded != "false") {
        setState(() {
          loading = false;
          textValue = "Apply";
        });
        print(downloaded);
      } else {
        setState(() {
          loading = false;
        });
        return;
      }
    }
  }

  // Toast Notification Function
  _showToast(String message) async {
    var result = await platform.invokeMethod("showToast", message);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Hero(
        tag: context.watch<WallpaperProvider>().uniqueID,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.only(right: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: context.watch<WallpaperProvider>().wallpaper,
            placeholder: (context, url) => Center(
              child: Text(
                'wox',
                style: TextStyle(
                    fontFamily: 'Euclid',
                    fontWeight: FontWeight.bold,
                    fontSize: 33,
                    color: Colors.grey.withOpacity(0.6),
                    decoration: TextDecoration.none),
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Text(
                'error',
                style: TextStyle(
                    fontFamily: 'Euclid',
                    fontWeight: FontWeight.bold,
                    fontSize: 33,
                    color: Colors.red.withOpacity(0.8),
                    decoration: TextDecoration.none),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: 50,
        left: 20,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.black87,
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 50,
        left: 0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                var wallURL =
                    Provider.of<WallpaperProvider>(context, listen: false)
                        .wallpaper;
                var wallID =
                    Provider.of<WallpaperProvider>(context, listen: false)
                        .wallpaperUUID;
                downloadFile(wallURL, wallID);
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: Align(
                  alignment: Alignment.center,
                  child: !loading
                      ? Text(
                          textValue,
                          style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              fontFamily: 'Euclid'),
                        )
                      : const SizedBox(
                          height: 16,
                          width: 16,
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black87,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      )
    ]);
  }

  Widget containerChoice(String text, String type, String path) {
    return GestureDetector(
      onTap: () {
        setWallpaperFromFile(path, type);
        _showToast("Wallpaper Applied.");
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          text,
          style: const TextStyle(
              fontFamily: 'Euclid',
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none),
        ),
      ),
    );
  }
}
