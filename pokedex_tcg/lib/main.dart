import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'views/home_page.dart';
import 'views/search_page.dart';
import 'views/explore_page.dart';
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/explore_viewmodel.dart';
import 'viewmodels/detail_viewmodel.dart';
import 'widgets/app_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => ExploreViewModel()),
        ChangeNotifierProvider(create: (_) => DetailViewModel()),
      ],
      child: MaterialApp(
        title: 'Pokédex TCG',
        theme: AppTheme.lightTheme(),
        home: const MainNavigation(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const ExplorePage(),
  ];

  final List<String> _titles = [
    'Pokédex TCG',
    'Search Cards',
    'Explore Cards',
  ];

  void _onNavigate(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      drawer: AppDrawer(onNavigate: _onNavigate),
      body: _pages[_selectedIndex],
    );
  }
}
