import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/screens/Pages/add_image.dart';
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
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text(
              'Home',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            icon: Icon(Icons.home),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            title: Text(
              'Search',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            icon: Icon(Icons.search),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            title: Text(
              'Add',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            icon: Icon(Icons.add),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            title: Text(
              'Favorite',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            icon: Icon(Icons.favorite_border),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            title: Text(
              'Profile',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            icon: Icon(Icons.person_outline),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
