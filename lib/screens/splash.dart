import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wox/screens/home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const Main())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(alignment: Alignment.center, children: const [
            Text(
              'wox',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4063F3),
                  fontSize: 30 * 2.7),
            ),
            Positioned(
                bottom: 50,
                child: Text(
                  "Devsly",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 19),
                )),
          ])),
    );
  }
}
