import 'package:flutter/material.dart';
import 'package:flutter_app2/animeList/pageAnimeList.dart';
import 'package:flutter_app2/animeSaison/pageAnimeSaison.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/pageAuthentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'MAL App';
  static Authentication _auth;

  static Color activeIconColor = Color.fromRGBO(0, 0, 0, 1);
  static Color passiveIconColor = Color.fromRGBO(0, 0, 0, 0.5);
  static Color bottomNavigationBarColor = Color.fromRGBO(31, 78, 130, 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      ),
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
    if (_selectedIndex == 0 && index == 0) {
      (_widgetOptions[0] as PageAnimeList).state.goToPage(0);
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget body;

  @override
  void initState() {
    super.initState();
    body = Center(
      child: CircularProgressIndicator(),
    );
    verifierConnection();
  }

  verifierConnection() async {
    print("verifierConnection");
    Authentication auth = Authentication.getSingleton();
    if (!auth.isTokenExists()) {
      auth.token = await auth.getTokenInStorage();
      if (!auth.isTokenExists()) {
        print("vous devez vous connecter");
        setState(() {
          body = PageAuthentication.getSingleton(chargerPage);
        });
      } else {
        print("vous etes connecte");
        chargerPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Color.fromRGBO(32 , 32, 32, 1),
        body: body,
        /*body: _widgetOptions.elementAt(_selectedIndex),*/
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(MediaQuery.of(context).size.width / 25),
              //pour avoir un border radius a peu pres responsive
              bottom: Radius.circular(MediaQuery.of(context).size.width / 40)),
          child: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
                selectedIconTheme: IconThemeData(
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
                unselectedIconTheme: IconThemeData(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                ),
                selectedLabelStyle: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontWeight: FontWeight.w800
                ),
                unselectedLabelStyle: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    fontWeight: FontWeight.w800
                ),
                selectedFontSize: MediaQuery.of(context).size.height/60,
                unselectedFontSize: MediaQuery.of(context).size.height/60,
                backgroundColor: MyApp.bottomNavigationBarColor,

                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.apps),
                    label: 'My List',
                  ),
                  BottomNavigationBarItem(

                    icon: Icon(Icons.calendar_today),
                    label: 'Seasonal',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Color.fromRGBO(0, 0, 0, 1),
                onTap: (int) {
                  print("changement de page");
                  _onItemTapped(int);
                  chargerPage();
                })
          ),
        ));
  }

  chargerPage() {
    setState(() {
      body = IndexedStack(
        children: _widgetOptions,
        index: _selectedIndex,
      );
    });
  }
}
