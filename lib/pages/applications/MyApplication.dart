import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobseekr/widget/SavedJobCard.dart';

class MyApplication extends StatefulWidget {
  const MyApplication({Key? key}) : super(key: key);

  @override
  State<MyApplication> createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'My Applications',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.questionCircle, color: Colors.black),
          )
        ],
        bottom: TabBar(
          indicatorColor: Colors.blue,
          controller: _tabController,
          labelStyle: TextStyle(color: Colors.black),
          tabs: [
            Tab(text: 'Applied jobs'),
            Tab(text: 'Interview Invites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Widget for the first tab (Applied jobs)
          SingleChildScrollView(
            child: Column(
              children: [
                SavedJobCard(), // Replace with actual content for Applied jobs tab
                // Additional widgets as needed
              ],
            ),
          ),
          // Widget for the second tab (Interview Invites)
          SingleChildScrollView(
            child: Center(
              child: Text(
                  'Interview Invites Page'), // Replace with actual content for Interview Invites tab
            ),
          ),
        ],
      ),
    );
  }
}
