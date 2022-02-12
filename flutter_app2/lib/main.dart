import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/token/loadStatus.dart';
import 'package:flutter_app2/icons/custom_icons_icons.dart';
import 'package:flutter_app2/theme/theme.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/pageAuthentication.dart';
import 'package:flutter_app2/view/animeList/pageAnimeList.dart';
import 'package:flutter_app2/view/animeNews/pageNews.dart';
import 'package:flutter_app2/view/animeSaison/pageAnimeSaison.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static Authentication _auth;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MAL client',
        theme: theme,
        darkTheme: darkTheme,
        home: MyStatefulWidget(),
      ),
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

  void _onItemTapped(int index) {
    if (_selectedIndex == 0 && index == 0) {
      //(_widgetOptions[0] as PageAnimeList).state.goToPage(0);
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  LoadStatus _loadStatus = LoadStatus.loading;

  @override
  void initState() {
    super.initState();
    verifierConnection();
    AdaptiveTheme.of(context)
        .modeChangeNotifier
        .addListener(() => setState(() {}));
  }

  verifierConnection() async {
    Authentication auth = Authentication.getSingleton();

    LoadStatus tempStatus = await auth.tryConnection();
    setState(() {
      _loadStatus = tempStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loadStatus == LoadStatus.loading
        ? new Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
                color: AdaptiveTheme.of(context).theme.hintColor),
          )
        : _loadStatus == LoadStatus.needAction
            ? PageAuthentication.getSingleton(chargerPageApresConnection)
            : Scaffold(
                extendBody: true,
                body: IndexedStack(
                  index: _selectedIndex,
                  children: <Widget>[
                    PageAnimeList(),
                    PageAnimeSaison(),
                    PageNews(),
                  ],
                ),
                /*body: _widgetOptions.elementAt(_selectedIndex),*/
                bottomNavigationBar: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                          MediaQuery.of(context).size.width / 25),
                      //pour avoir un border radius a peu pres responsive
                      bottom: Radius.circular(
                          MediaQuery.of(context).size.width / 40)),
                  child: BottomNavigationBar(
                    selectedFontSize: MediaQuery.of(context).size.width / 30,
                    unselectedFontSize: MediaQuery.of(context).size.width / 30,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(CustomIcons.applications),
                        label: 'My List',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CustomIcons.calendrier),
                        label: 'Seasonal',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CustomIcons.search),
                        label: 'Search',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    showUnselectedLabels: false,
                    iconSize: MediaQuery.of(context).size.width / 15,
                    onTap: (int) {
                      print("changement de page");
                      _onItemTapped(int);
                    },
                  ),
                ),
              );
  }

  chargerPageApresConnection() {
    setState(() {
      _loadStatus = LoadStatus.loadComplete;
    });
  }
}
