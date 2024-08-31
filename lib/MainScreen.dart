import 'package:flutter/material.dart';
import 'package:jobseekr/Service/UserService.dart';
import 'package:jobseekr/pages/applications/MyApplication.dart';
import 'package:jobseekr/pages/bookmark/Bookmark.dart';
import 'package:jobseekr/pages/jobs/JobsScreen.dart';
import 'package:jobseekr/pages/profile/ProfileScreen.dart';

class MainScreen extends StatefulWidget {
  final int i; // Define the parameter i in the StatefulWidget

  MainScreen(this.i); // Constructor to initialize i

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, dynamic>? userProfile = {};

  List<Map<String, dynamic>>? companyData = [];

  int _selectedIndex = 0; // Initialize _selectedIndex to 0

  @override
  void initState() {
    super.initState();
    getUserProfile();

    // Set _selectedIndex based on widget.i
    if (widget.i == 0) {
      _selectedIndex = 0; // Display JobsScreen initially
    } else if (widget.i == 2) {
      _selectedIndex = 2; // Display ProfileScreen initially
    }
  }

  getUserProfile() {
    try {
      UserService userService = new UserService();
      userService
          .getUserProfile()
          .then((value) => {setState(() => userProfile = value)});
    } catch (e) {
      print(e);
    }
  }

  static List<Widget> _widgetOptions = [
    JobsScreen(),
    MyApplication(),
    //  Container(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String initials = '';
    if (userProfile?["fname"] != null && userProfile?["fname"]!.isNotEmpty) {
      initials += userProfile?["fname"]![0];
    }
    if (userProfile?["lname"] != null && userProfile?["lname"]!.isNotEmpty) {
      initials += userProfile?["lname"]![0];
    }

    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        elevation: 0,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1 ? Icons.note_alt : Icons.note_alt_outlined,
            ),
            label: 'Applications',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     _selectedIndex == 2 ? Icons.work : Icons.work_outline,
          //   ),
          //   label: 'Jobs',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
