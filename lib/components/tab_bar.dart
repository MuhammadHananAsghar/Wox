import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wox/providers/search_provider.dart';
import 'package:wox/screens/search.dart';

class TabView extends StatefulWidget {
  const TabView({Key? key}) : super(key: key);

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTab);
  }

  void _navigate(to) {
    context.read<SearchQuery>().setQuery(to);
    Navigator.of(context).push(_createRoute(const Search()));
  }

  void _handleTab() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          _navigate('Nature');
          break;
        case 1:
          _navigate('Animals');
          break;
        case 2:
          _navigate('Abstract');
          break;
        case 3:
          _navigate('Cars');
          break;
        case 4:
          _navigate('Cartoons');
          break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
      isScrollable: true,
      controller: _tabController,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(
            25.0,
          ),
          color: const Color(0xFF4063F3)),
      labelColor: Colors.white,
      labelStyle:
          const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Euclid'),
      unselectedLabelColor: Colors.black,
      tabs: const [
        Tab(
          text: 'Nature',
        ),
        Tab(
          text: 'Animals',
        ),
        Tab(
          text: 'Abstract',
        ),
        Tab(
          text: 'Cars',
        ),
        Tab(
          text: 'Cartoons',
        ),
      ],
    );
  }
}

Route _createRoute(route) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => route,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
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
