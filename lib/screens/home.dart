// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wox/components/header.dart';
import 'package:wox/components/menu_button.dart';
import 'package:wox/components/wallview_section.dart';
import 'package:wox/components/searchbar.dart';
import 'package:wox/components/tab_bar.dart';
import 'package:wox/screens/offline.dart';
import 'package:wox/screens/search.dart';
import 'package:provider/provider.dart';
import 'package:wox/providers/search_provider.dart';
import 'package:flutter_network_connectivity/flutter_network_connectivity.dart';
import 'package:wox/utils/ad_helper.dart';

class Main extends StatefulWidget {
  Main({Key? key}) : super(key: key) {
    _initGoogleMobileAds();
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  // BannerAds
  late BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  _initBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: BannerAd.testAdUnitId,
      listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {}),
      request: const AdRequest(),
    );

    _bannerAd?.load();
  }

  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  // Global Key for Handling Events in Scafold
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  // Internet Connection
  FlutterNetworkConnectivity flutterNetworkConnectivity =
      FlutterNetworkConnectivity(
    isContinousLookUp:
        true, // optional, false if you cont want continous lookup
    lookUpDuration: const Duration(
        seconds: 5), // optional, to override default lookup duration
    lookUpUrl: 'google.com', // optional, to override default lookup url
  );

  bool isNetworkConnectedOnCall = false;

  // For Navigating
  void _navigate(to) {
    context.read<SearchQuery>().setQuery(to);
    Navigator.of(context).push(_createRoute(const Search()));
  }

  // For Checking Internet Connection
  _checkConectivity() async {
    bool connection =
        await flutterNetworkConnectivity.isInternetConnectionAvailable();
    setState(() {
      isNetworkConnectedOnCall = connection;
    });
  }

  @override
  Widget build(BuildContext context) {
    _checkConectivity();
    return isNetworkConnectedOnCall
        ? Scaffold(
            key: _key,
            backgroundColor: const Color(0xFFFFFFFF),
            drawer: SafeArea(
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
                  child: Drawer(
                    backgroundColor: const Color(0xFF212639),
                    width: 260,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0 * 1.2, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'wox',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 30 * 2.7),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          textView("Nature"),
                          textView("Abstract"),
                          textView("Animals"),
                          textView("Cars"),
                          textView("Cartoons"),
                        ],
                      ),
                    ),
                  )),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: const MenuButton(),
                            onTap: () {
                              _key.currentState!.openDrawer();
                            },
                          ),
                          InkWell(
                            child: const Icon(Icons.help_outline),
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  "Developer: Muhammad Hanan Asghar",
                                  style: TextStyle(fontFamily: 'Euclid'),
                                ),
                                duration: Duration(milliseconds: 1000),
                              ));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      const Header(),
                      const SizedBox(
                        height: 20,
                      ),
                      const SearchBar(),
                      const SizedBox(
                        height: 20,
                      ),
                      const TabView(),
                      const SizedBox(
                        height: 40,
                      ),
                      const WallView(heading: 'Mountains'),
                      const SizedBox(
                        height: 20,
                      ),
                      const WallView(heading: 'Cars'),
                      const SizedBox(
                        height: 20,
                      ),
                      const WallView(heading: 'Attitude'),
                      const SizedBox(
                        height: 20,
                      ),
                      const WallView(heading: 'Sea'),
                      const SizedBox(
                        height: 20,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Devsly',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: _isAdLoaded
                ? SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  )
                : const SizedBox(),
          )
        : const Offline();
  }

  Widget textView(text) {
    return InkWell(
      onTap: () {
        _navigate(text);
        _key.currentState!.closeDrawer();
      },
      child: Column(
        children: [
          Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 23),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

Route _createRoute(route) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => route,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
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
