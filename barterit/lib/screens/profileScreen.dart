import 'dart:async';
import 'package:barterit/models/user.dart';
import 'package:barterit/screens/addScreen.dart';
import 'package:barterit/screens/homeScreen.dart';
import 'package:barterit/screens/loginScreen.dart';
import 'package:barterit/screens/registrationScreen.dart';
import 'package:flutter/material.dart';

class profilePage extends StatefulWidget {
  final User user;

  const profilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  late double screenHeight, screenWidth;
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                height: screenHeight * 0.25,
                width: screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(4),
                      width: screenWidth * 0.4,
                      child: Image.asset("assets/images/profile.png"),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Text(
                              widget.user.name.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              widget.user.email.toString(),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              widget.user.phone.toString(),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              widget.user.datereg.toString(),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: screenWidth,
                alignment: Alignment.center,
                color: Theme.of(context).colorScheme.background,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                height: screenHeight * 0.5,
                child: ListView(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const loginScreen(),
                          ),
                        );
                      },
                      child: const Text("LOGIN"),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const registrationScreen(),
                          ),
                        );
                      },
                      child: const Text("REGISTRATION"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
