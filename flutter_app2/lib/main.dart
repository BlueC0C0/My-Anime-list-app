import 'package:flutter/material.dart';
import 'package:flutter_app2/animeList/pageAnimeList.dart';
import 'package:flutter_app2/animeSaison/pageAnimeSaison.dart';
import 'package:flutter_app2/token/authentication.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  static const String _title = 'MAL App';
  static Authentication _auth;



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}


class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}


class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    PageAnimeList(),
    PageAnimeSaison(),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    if(_selectedIndex==0 && index==0){
      (_widgetOptions[0] as PageAnimeList).goToFirstPage();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 17, 17, 1),
      body: IndexedStack(
        children: _widgetOptions,
        index: _selectedIndex,
      ),
      /*body: _widgetOptions.elementAt(_selectedIndex),*/
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'AnimeList',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fiber_new),
            label: 'saison',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'user',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}