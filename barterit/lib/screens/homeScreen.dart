import 'package:barterit/screens/addScreen.dart';
import 'package:barterit/screens/profileScreen.dart';
import 'package:barterit/screens/tradeScreen.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';

class homeScreen extends StatefulWidget {
  final User user;

  const homeScreen({super.key, required this.user});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Main";

  @override
  void initState() {
    super.initState();
    //print(widget.user.name);
    print("Mainscreen");
    tabchildren = [
      homeScreen(
        user: widget.user,
      ),
      tradeScreen(user: widget.user),
      profilePage(user: widget.user),
      addScreen(user: widget.user)
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //   body: tabchildren[_currentIndex],
        //   bottomNavigationBar: BottomNavigationBar(
        //       onTap: onTabTapped,
        //       type: BottomNavigationBarType.fixed,
        //       currentIndex: _currentIndex,
        //       items: const [
        //         BottomNavigationBarItem(icon: Icon(Icons.home), label: "Main"),
        //         BottomNavigationBarItem(
        //             icon: Icon(
        //               Icons.plus_one_rounded,
        //             ),
        //             label: "Add"),
        //         BottomNavigationBarItem(
        //             icon: Icon(
        //               Icons.person,
        //             ),
        //             label: "Profile"),
        //       ]),
        );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Main";
      }
      if (_currentIndex == 1) {
        maintitle = "Add";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }
}
