// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_network_connectivity/flutter_network_connectivity.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wox/components/grids.dart';
import 'package:wox/providers/search_provider.dart';
import 'package:provider/provider.dart';
import 'package:wox/screens/offline.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.black87,
                  size: 35,
                ),
              ),
            ),
            body: SingleChildScrollView(
                child: SafeArea(
                    child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${context.watch<SearchQuery>().query} Wallpapers',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Grid()
                ],
              ),
            ))),
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
}
