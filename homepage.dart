import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/categoryClass.dart';
import 'package:wallpaper_app/favouriteClass.dart';
import 'package:wallpaper_app/homeClass.dart';
class homepage extends StatefulWidget {
  const homepage({super.key});
  @override
  State<homepage> createState() => _homepageState();
}
int ci = 0;
Widget selectedBody = homeClass();
class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.white),
                  label: "Home",
                  backgroundColor: Colors.grey.shade500,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category, color: Colors.white),
                  label: "Category",
                  backgroundColor: Colors.grey.shade500,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite, color: Colors.white),
                  label: "Favorite",
                  backgroundColor: Colors.grey.shade500,
                ),
              ],
              type: BottomNavigationBarType.shifting,
              currentIndex: ci,
              onTap: onClicked,
            ),
        body: selectedBody,
        ),

      );

  }

  void onClicked(int value) {
    switch (value) {
      case 0:
        selectedBody = homeClass();
        break;
      case 1:
        selectedBody = Categoryclass();
        break;
      case 2:
        selectedBody = FavouriteClass();
        break;
    }

    setState(() {
      ci = value;
    });
  }
}