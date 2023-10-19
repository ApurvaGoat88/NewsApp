import 'package:bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:news_project/main.dart';
import 'package:news_project/provider/news_provider.dart';
import 'package:news_project/screens/BookMarks.dart';
import 'package:news_project/screens/homepage.dart';
import 'package:news_project/screens/startpage.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, value, child) {
        return Scaffold(
          body: _body(),
          bottomNavigationBar: _bottomNavBar(),
        );
      },
    );
  }

  Widget _body() => SizedBox.expand(
        child: IndexedStack(
          index: _currentIndex,
          children: const <Widget>[Body(), BookMarks(), PAge3(), Page4()],
        ),
      );

  Widget _bottomNavBar() => BottomNavBar(
        showElevation: true,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          setState(() {});
        },
        items: <BottomNavBarItem>[
          BottomNavBarItem(
              title: 'Home',
              icon: const Icon(Icons.home),
              activeColor: Colors.orange,
              inactiveColor: Colors.black,
              activeBackgroundColor: Colors.white),
          BottomNavBarItem(
              title: 'BookMarks',
              icon: const Icon(Icons.bookmark),
              activeColor: Colors.orange,
              inactiveColor: Colors.black,
              activeBackgroundColor: Colors.white),
          BottomNavBarItem(
              title: 'Message',
              icon: const Icon(Icons.chat_bubble),
              inactiveColor: Colors.black,
              activeColor: Colors.orange,
              activeBackgroundColor: Colors.white),
          BottomNavBarItem(
              title: 'Settings',
              icon: const Icon(Icons.settings),
              inactiveColor: Colors.black,
              activeColor: Colors.orange,
              activeBackgroundColor: Colors.white),
        ],
      );
}

class PAge3 extends StatefulWidget {
  const PAge3({super.key});

  @override
  State<PAge3> createState() => _PAge3State();
}

class _PAge3State extends State<PAge3> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
