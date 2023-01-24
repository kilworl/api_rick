import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_graphlq/pages/characters_page.dart';
import 'package:rick_graphlq/pages/episodes_page.dart';
import 'package:rick_graphlq/pages/locations_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter(); // for cache
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GraphQL Demo',
      theme: ThemeData(
          fontFamily: 'Rick and Morty Font', brightness: Brightness.dark),
      home: const NavBar(),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 1;
  final tabs = [
    CharactersPage(title: 'GraphQL Demo'),
    EpisodesPage(title: 'GraphQL Demo'),
    LocationsPage(title: 'GraphQL Demo'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Episodios',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Episodes',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_searching),
              label: 'locations',
              backgroundColor: Colors.blue),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
