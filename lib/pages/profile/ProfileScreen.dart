// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jobseekr/Service/AuthService.dart';
import 'package:jobseekr/Service/UserService.dart';
import 'package:jobseekr/pages/profile/screens/AboutComponent.dart';
import 'package:jobseekr/pages/profile/screens/CertificationScreen.dart';
import 'package:jobseekr/widget/CertificationWidget.dart';
import 'package:jobseekr/widget/CustomAppBar.dart';
import 'package:jobseekr/pages/profile/screens/ExperienceComponent.dart';
import 'package:jobseekr/pages/profile/screens/LinkScreen.dart';
import 'package:jobseekr/pages/profile/screens/NameComponent.dart';
import 'package:jobseekr/widget/LinkWidget.dart';
import 'package:jobseekr/themes/styles.dart';
import 'package:jobseekr/widget/LoginButton.dart';
import 'package:jobseekr/widget/OutlineButton.dart';
import 'package:jobseekr/widget/PersonalInformationComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;

  Map<String, dynamic>? userData = {};

  AuthService auth = new AuthService(); // Define userData as a Map

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchProfile();
  }

  Future<void> fetchProfile() async {
    setState(() {
      isLoading = true;
    });
    UserService uservice = new UserService();

    userData = await uservice.getUserProfile();

    setState(() {
      isLoading = false;
    });
  }

  void refreshProfile() {
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    String initials = '';
    if (userData?["fname"] != null && userData?["fname"]!.isNotEmpty) {
      initials += userData?["fname"]![0];
    }
    if (userData?["lname"] != null && userData?["lname"]!.isNotEmpty) {
      initials += userData?["lname"]![0];
    }

    return isLoading
        ? Scaffold(
            appBar: CustomAppBar(
                firstName: userData?["fname"] ?? "",
                lastName: userData?["lname"] ?? "",
                companyName: 'JobSeekr',
                pageIndex: 2),
            body: Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ))
        : Scaffold(
            appBar: CustomAppBar(
                firstName: userData?["fname"] ?? "",
                lastName: userData?["lname"] ?? "",
                companyName: 'JobSeekr',
                pageIndex: 2),
            body: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 50, horizontal: 50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Set radius here
                                  color: Color.fromARGB(255, 241, 240, 240),
                                  // Set container color if needed
                                ),
                                child: Text(
                                  initials.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight
                                          .bold, // Increase font size here
                                      color: Colors
                                          .black // Set text color to black
                                      ),
                                ),
                              ),
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors
                                          .blue // Set container color to black
                                      ),
                                  child: IconButton(
                                    color: Colors.white,
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                    onPressed: () {
                                      // Add your edit icon onPressed logic here
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child:
                                  Container()), // Added Expanded widget to push Text to the center
                          Text(
                            '${userData?["fname"] != null && (userData?["fname"] as String).isNotEmpty ? (userData?["fname"] as String)[0].toUpperCase() + (userData?["fname"] as String).substring(1).toLowerCase() : ""} '
                            '${userData?["lname"] != null && (userData?["lname"] as String).isNotEmpty ? (userData?["lname"] as String)[0].toUpperCase() + (userData?["lname"] as String).substring(1).toLowerCase() : ""}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                              child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NameComponent(
                                            fname: userData?["fname"] as String,
                                            lname: userData?["lname"] as String,
                                          )));
                            },
                            icon: Icon(Icons.edit_outlined),
                          ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('0',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Text('Connections'),
                          SizedBox(width: 16),
                          Text('0',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Text('Followers')
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(15),
                        width: double.infinity, // Full width
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Black26 color
                          borderRadius: BorderRadius.circular(10), // Radius 10
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3, // 75% of width
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your profile is 15% complete add missing important information',
                                    style: TextStyle(
                                        color: linkedInMediumGrey86888A),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Add Education',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1, // 25% of width
                              child: CircleAvatar(
                                backgroundColor: Color.fromARGB(74, 230, 145,
                                    179), // Example background color for Avatar
                                child: Text(
                                  'CA',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      //
                      //
                      //
                      //
                      //

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("About",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                (userData?["about"] == "" ||
                                        userData?["about"] == null)
                                    ? Container()
                                    : IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AboutComponent(
                                                      userData:
                                                          userData?["about"]
                                                              as String?,
                                                    )),
                                          );
                                        },
                                        icon: Icon(Icons.edit_outlined))
                              ]),
                          SizedBox(height: 10),
                          (userData?["about"] == "" ||
                                  userData?["about"] == null)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                        "Summary contibutes 10% to your profile",
                                      ),
                                      SizedBox(height: 20),
                                      OutlineButton(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AboutComponent()),
                                          );
                                        },
                                        title: "Add About Yourself",
                                        hasIcon: true,
                                        icon: Icon(Icons.add),
                                      ),
                                    ])
                              : Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text("${userData?["about"]}")),
                        ],
                      ),
                      //
                      //
                      //
                      //
                      // SizedBox(height: 20),
                      // Text("Work Experience",
                      //     style: TextStyle(
                      //         fontSize: 16, fontWeight: FontWeight.bold)),
                      // SizedBox(height: 10),
                      // userData?["experiences"] == null ||
                      //         userData?["experiences"] == "" ||
                      //         (userData?["experiences"] as List).isEmpty
                      //     ? Text(
                      //         "Showcase your career. Quantify your impact using numbers, heighlight the important project you did and the skills you mastered.",
                      //       )
                      //     : Container(),
                      // userData?["experiences"] == null ||
                      //         userData?["experiences"] == "" ||
                      //         (userData?["experiences"] as List).isEmpty
                      //     ? Text(
                      //         "Work Experience contributes 20% to your profile",
                      //       )
                      //     : Container(),

                      // userData?["experiences"] == null ||
                      //         userData?["experiences"] == "" ||
                      //         (userData?["experiences"] as List).isEmpty
                      //     ? SizedBox(height: 20)
                      //     : Container(),
                      // userData?["experiences"] == null ||
                      //         userData?["experiences"] == "" ||
                      //         (userData?["experiences"] as List).isEmpty
                      //     ? OutlineButton(
                      //         title: "Add Work Experience",
                      //         hasIcon: true,
                      //         icon: Icon(Icons.add),
                      //         onTap: () {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => ExperienceComponent(),
                      //             ),
                      //           );
                      //         },
                      //       )
                      //     : Column(
                      //         children: (userData?["experiences"] as List)
                      //             .map((experience) {
                      //           return Container(
                      //               width: MediaQuery.of(context).size.width,
                      //               margin: EdgeInsets.symmetric(vertical: 8.0),
                      //               decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 border: Border.all(
                      //                   color: Colors.grey,
                      //                 ),
                      //                 borderRadius: BorderRadius.circular(8.0),
                      //               ),
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Column(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   Container(
                      //                     width:
                      //                         MediaQuery.of(context).size.width,
                      //                     padding: EdgeInsets.all(16.0),
                      //                     color: Colors.blueGrey[50],
                      //                     child: Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         Image.asset(
                      //                           "assets/experience.webp",
                      //                           height: 40,
                      //                           width: 40,
                      //                         ),
                      //                         SizedBox(height: 10),
                      //                         Column(
                      //                           crossAxisAlignment:
                      //                               CrossAxisAlignment.start,
                      //                           children: [
                      //                             Text(
                      //                               experience["company"],
                      //                               style: TextStyle(
                      //                                 fontSize: 18.0,
                      //                                 fontWeight:
                      //                                     FontWeight.bold,
                      //                               ),
                      //                             ),
                      //                             Text(
                      //                               experience["title"] ??
                      //                                   'Title Not Available',
                      //                               style: TextStyle(
                      //                                 fontSize: 12.0,
                      //                                 color: Colors.grey[600],
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                   Row(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.spaceBetween,
                      //                       children: [
                      //                         Column(
                      //                             crossAxisAlignment:
                      //                                 CrossAxisAlignment.start,
                      //                             children: [
                      //                               Padding(
                      //                                   padding:
                      //                                       EdgeInsets.only(
                      //                                           left: 20,
                      //                                           top: 20),
                      //                                   child: Text(
                      //                                     "${experience["fromYear"]} - ${experience["toYear"]}",
                      //                                     style: TextStyle(
                      //                                         fontSize: 12,
                      //                                         fontWeight:
                      //                                             FontWeight
                      //                                                 .bold),
                      //                                   )),
                      //                               Padding(
                      //                                   padding:
                      //                                       EdgeInsets.only(
                      //                                           left: 20,
                      //                                           top: 4),
                      //                                   child: Text(
                      //                                     experience[
                      //                                         "employmentType"],
                      //                                     style: TextStyle(
                      //                                         fontSize: 12),
                      //                                   ))
                      //                             ]),
                      //                         Padding(
                      //                             padding: EdgeInsets.only(
                      //                                 right: 20, top: 4),
                      //                             child: Icon(Icons.more_vert))
                      //                       ])
                      //                 ],
                      //               ));
                      //         }).toList(),
                      //       ),
                      // //
                      // //
                      // //
                      // //
                      // SizedBox(height: 20),
                      // Text("Education",
                      //     style: TextStyle(
                      //         fontSize: 16, fontWeight: FontWeight.bold)),
                      // SizedBox(height: 10),

                      // userData?["education"] == null ||
                      //         userData?["education"] == "" ||
                      //         (userData?["education"] as List).isEmpty
                      //     ? Text(
                      //         "Education is the lauchpad for your professional journey. Highlight what have you learnt and how it is relevant to your future employer.",
                      //       )
                      //     : Container(),
                      // userData?["education"] == null ||
                      //         userData?["education"] == "" ||
                      //         (userData?["education"] as List).isEmpty
                      //     ? Text(
                      //         "Education contributes 25% to your profile",
                      //       )
                      //     : Container(),
                      // SizedBox(height: 20),
                      // OutlineButton(
                      //   title: "Add Education",
                      //   hasIcon: true,
                      //   icon: Icon(Icons.add),
                      // ),

                      // //
                      // //
                      // //
                      // //
                      // SizedBox(height: 20),
                      // Text("Awards & Achivements",
                      //     style: TextStyle(
                      //         fontSize: 16, fontWeight: FontWeight.bold)),
                      // SizedBox(height: 10),
                      // Text(
                      //   "Share your accolades with the recruiter and get an edge against other applicants. .",
                      // ),

                      // SizedBox(height: 20),
                      // OutlineButton(
                      //   title: "Add Awards",
                      //   hasIcon: true,
                      //   icon: Icon(Icons.add),
                      // ),

                      CertificationWidget(
                        refreshProfile: refreshProfile,
                        userData: userData!,
                      ),

                      LinkWidget(
                        refreshProfile: refreshProfile,
                        userData: userData!,
                      ),
                      PersonalInformationComponent(userData!),
                      InkWell(
                          onTap: () => {auth.logout()}, child: Text("Logout"))
                    ],
                  ),
                ),
              ],
            )),
          );
  }
}
