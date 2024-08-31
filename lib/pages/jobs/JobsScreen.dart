import 'package:flutter/material.dart';
import 'package:jobseekr/MainScreen.dart';
import 'package:jobseekr/Service/CompanyService.dart';

import 'package:jobseekr/Service/UserService.dart';
import 'package:jobseekr/pages/SearchAppearance/SeachAppearances.dart';
import 'package:jobseekr/pages/jobs/SearchJobScreen.dart';
import 'package:jobseekr/widget/JobCard.dart';
import 'package:jobseekr/widget/Navigation.dart';
import 'package:jobseekr/widget/ProfileStatus.dart';
import 'package:jobseekr/widget/TopCompanies.dart';
import 'package:jobseekr/pages/profile/ProfileScreen.dart';
import 'package:jobseekr/pages/profile/screens/AboutComponent.dart';
import 'package:jobseekr/widget/CustomAppBar.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({Key? key}) : super(key: key);

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String? profilePic;

  bool isLoading = false;

  Map<String, dynamic>? userProfile = {};

  List<Map<String, dynamic>>? companyData = [];

  int profileViewCounts = 0;

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  getUserProfile() {
    try {
      UserService userService = new UserService();
      userService
          .getUserProfile()
          .then((value) => {setState(() => userProfile = value)});

      userService
          .getUserProfileViews()
          .then((value) => setState(() => profileViewCounts = value!.length));
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllCompanies() async {
    try {
      CompanyService cService = CompanyService();
      List<Map<String, dynamic>>? companies = await cService.getAllCompanies();
      setState(() {
        companyData = companies ?? [];
        isLoading = false;
      });
    } catch (ex) {
      print('Error fetching companies: $ex');
      setState(() {
        isLoading = false;
      });
    }
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

    return isLoading
        ? Scaffold(
            appBar: CustomAppBar(
              firstName: userProfile?["fname"] ?? "",
              lastName: userProfile?["lname"] ?? "",
              companyName: 'JobSeekr',
              pageIndex: 0,
            ),
            body: Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ))
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              bottom: PreferredSize(
                  preferredSize:
                      Size.fromHeight(56.0), // Adjust the height as needed
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchJobScreen()));
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: Icon(Icons.search),
                          fillColor: Colors.grey[100],
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  )),
              firstName: userProfile?["fname"] ?? "",
              lastName: userProfile?["lname"] ?? "",
              companyName: 'JobSeekr',
              pageIndex: 0,
            ),
            body: SingleChildScrollView(
                child: isLoading
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              alignment: Alignment.center,
                              child: Image.asset("assets/load.gif", height: 20),
                            ),
                          ],
                        )))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ProfileStatus(context, profilePic, initials,
                                        userProfile, ontap: () {
                                      Navigation(MainScreen(2), context);
                                    },
                                        title:
                                            "${userProfile?["fname"]} \'s profile",
                                        subTitle: "Updated Today",
                                        buttonTitle: "View Profile",
                                        backgroundColor:
                                            Color.fromARGB(255, 250, 239, 250)),
                                    // SizedBox(width: 10),
                                    ProfileStatus(
                                        context,
                                        profilePic,
                                        profileViewCounts.toString(),
                                        userProfile, ontap: () {
                                      Navigation(SearchAppearance(), context);
                                    },
                                        title: "Search appearances",
                                        subTitle: "Last 90 Days",
                                        buttonTitle: "View all",
                                        backgroundColor:
                                            Color.fromARGB(255, 232, 241, 250)),

                                    ProfileStatus(
                                        context, profilePic, "29", userProfile,
                                        ontap: () {},
                                        title: "Recruiter action",
                                        subTitle: "Last 90 days",
                                        buttonTitle: "View all",
                                        backgroundColor:
                                            Color.fromARGB(255, 233, 249, 233))
                                  ],
                                ),
                              )),
                          userProfile?["about"] == null
                              ? Container()
                              : SizedBox(height: 10),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  userProfile?["about"] == null
                                      ? Container(
                                          color: Color.fromARGB(
                                              255, 241, 240, 240),
                                          padding: EdgeInsets.all(20),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "↑ Boost 8%",
                                                    style: TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Let recruiters know more \nabout your job",
                                                  ),
                                                  SizedBox(height: 30),
                                                  Row(
                                                    children: [
                                                      Container(
                                                          color:
                                                              Colors.blueAccent,
                                                          width: 15,
                                                          height: 5),
                                                      SizedBox(width: 10),
                                                      Container(
                                                          color: Color.fromARGB(
                                                              103,
                                                              255,
                                                              255,
                                                              255),
                                                          width: 5,
                                                          height: 5),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AboutComponent()));
                                                },
                                                child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color:
                                                            Colors.blueAccent,
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Text(
                                                      'Add Summary',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors
                                                              .blueAccent),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  userProfile?["company"] != null
                                      ? Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.black26,
                                          padding: EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "↑ Boost 8%",
                                                    style: TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Let recruiters know more \nabout your job",
                                                  ),
                                                  SizedBox(height: 30),
                                                  Row(
                                                    children: [
                                                      Container(
                                                          color: Color.fromARGB(
                                                              103,
                                                              255,
                                                              255,
                                                              255),
                                                          width: 5,
                                                          height: 5),
                                                      SizedBox(width: 10),
                                                      Container(
                                                          color:
                                                              Colors.blueAccent,
                                                          width: 15,
                                                          height: 5),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             EmploymentDetails()));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.blueAccent,
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Text(
                                                    'Add job profile',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Colors.blueAccent),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container()
                                ],
                              )),
                          SizedBox(height: 10),
                          JobCard(),
                          SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, top: 10, bottom: 10),
                                  child: Text(
                                    "Explore more jobs you may like",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 0,
                                  color: Color.fromARGB(255, 245, 245, 245),
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          child: Icon(Icons.work),
                                          backgroundColor:
                                              Color.fromARGB(206, 248, 186, 1),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "You might like",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "39 jobs",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Top Companies",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "Hiring for software development",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "View",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TopCompanies(),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                          Container(
                            color: Color.fromARGB(255, 245, 245, 245),
                            child: Column(
                              children: [
                                SizedBox(height: 40),
                                Center(
                                    child: Image.asset("assets/group.png",
                                        width: 60)),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "1000+ recruiters can contact you directly",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "Keep your profile updated to increase the chances of being contacted",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Center(
                                    child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors
                                          .blue, // Add your desired border color here
                                      width:
                                          2, // Adjust the border width as needed
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20,
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          10), // Adjust padding as needed
                                      child: Text(
                                        initials.toUpperCase(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                )
                                    // CircleAvatar(
                                    //   radius: 25,
                                    //   backgroundImage: NetworkImage(profilePic ?? ''),
                                    // ),
                                    ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.electric_bolt,
                                      size: 12,
                                    ),
                                    Text(
                                      "Takes less than 1 minute",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainScreen(2)));
                                      },
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Update profile',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      )));
  }
}
