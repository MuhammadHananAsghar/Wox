import 'package:flutter/material.dart';

class Offline extends StatefulWidget {
  const Offline({Key? key}) : super(key: key);

  @override
  State<Offline> createState() => _OfflineState();
}

class _OfflineState extends State<Offline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Image.asset(
            'assets/images/connection.png',
            fit: BoxFit.cover,
            height: 300,
            width: 300,
          ),
        ),
      ),
    );
  }
}
