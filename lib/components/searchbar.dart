import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wox/providers/search_provider.dart';
import 'package:wox/screens/search.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _tController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _tController.dispose();
    super.dispose();
  }

  void _navigate(to) {
    context.read<SearchQuery>().setQuery(to);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Search()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color.fromRGBO(244, 243, 243, 1)),
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: TextField(
          textCapitalization: TextCapitalization.words,
          controller: _tController,
          onSubmitted: (value) {
            if (_tController.text == '') {
              return;
            } else {
              _navigate(_tController.text);
              _tController.text = '';
            }
          },
          decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black87,
              ),
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
        ),
      ),
    );
  }
}
