import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logique_mobile_developer_test/di/di.dart';
import 'package:logique_mobile_developer_test/presentaions/cubits/cubits.dart';

import 'presentaions/pages/pages.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _savedPostCubit = getIt<SavedPostsCubit>();
  final PageController _pageController = PageController(initialPage: 0);
  final List _pageStack = [];
  int _pageIndex = 0;

  void pagePush(index) {
    if (_pageStack.isEmpty) {
      _pageStack.add(_pageIndex);
    }

    if (index == _pageIndex) {
      return;
    }

    if (_pageStack.contains(index) && _pageStack.length != 1) {
      _pageStack.remove(index);
    }

    if (!_pageStack.contains(_pageIndex)) {
      _pageStack.add(_pageIndex);
    }

    _pageController.jumpToPage(index);

    _pageIndex = index;
    setState(() {});
  }

  Future<bool> pagePop(BuildContext context) {
    if (_pageStack.isEmpty) {
      return Future<bool>.value(true);
    } else if (_pageIndex == 0) {
      return Future<bool>.value(true);
    } else {
      int t = _pageStack.removeLast();
      _pageIndex = (_pageIndex != t) ? t : _pageStack.removeLast();
      _pageController.jumpToPage(_pageIndex);
    }
    setState(() {});
    return Future<bool>.value(false);
  }

  void resetHome() {
    _pageStack.clear();
    _pageIndex = 0;
    _pageController.jumpToPage(_pageIndex);
    setState(() {});
  }

  @override
  void initState() {
    _savedPostCubit.fetchSavedPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOGIQUE Social',
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('id', 'ID')],
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      theme: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.light(
          primary: Colors.blueGrey,
          secondary: Colors.blueGrey.withOpacity(0.2),
          onSecondary: Colors.blueGrey.shade900,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.rubikTextTheme(ThemeData.light().textTheme),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
      ),
      home: WillPopScope(
        onWillPop: () => pagePop(context),
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              UserPage(),
              PostPage(),
              FavoritePage(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            animationDuration: const Duration(milliseconds: 1000),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: 'User',
              ),
              NavigationDestination(
                icon: Icon(Icons.dataset_outlined),
                selectedIcon: Icon(Icons.dataset),
                label: 'Post',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_outline),
                selectedIcon: Icon(Icons.favorite),
                label: 'Favorite',
              ),
            ],
            selectedIndex: _pageIndex,
            onDestinationSelected: pagePush,
          ),
        ),
      ),
    );
  }
}
