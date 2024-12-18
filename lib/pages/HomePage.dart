import 'package:flutter/material.dart';
import 'PasswordManagerPage.dart';
import 'ProfilePage.dart';

class HomePage extends StatefulWidget {
  final int userId;
  final String username;

  HomePage({required this.userId, required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      PasswordManagerPage(userId: widget.userId, username: widget.username),
      ProfilePage(userId: widget.userId),
    ];

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'Passwords'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}