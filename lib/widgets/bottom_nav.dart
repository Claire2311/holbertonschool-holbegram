import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/screens/Pages/add_post.dart';
import 'package:holbegram/screens/Pages/favorite.dart';
import 'package:holbegram/screens/Pages/feed.dart';
import 'package:holbegram/screens/Pages/profile_screen.dart';
import 'package:holbegram/screens/Pages/search.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List listItemsMenu = [
    {'name': 'Home', 'icon': Icons.home},
    {'name': 'Search', 'icon': Icons.search},
    {'name': 'Add', 'icon': Icons.add},
    {'name': 'Favorite', 'icon': Icons.favorite_border},
    {'name': 'Profile', 'icon': Icons.person_outline},
  ];

  List<BottomNavyBarItem> getBottomMenus(List tabs) {
    return tabs
        .map(
          (item) => BottomNavyBarItem(
            title: Container(
              alignment: Alignment.center,
              child: Text(
                item['name'],
                style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              ),
            ),
            icon: Icon(item['icon']),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [Feed(), Search(), AddImage(), Favorite(), Profile()],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: getBottomMenus(listItemsMenu),
      ),
    );
  }
}
