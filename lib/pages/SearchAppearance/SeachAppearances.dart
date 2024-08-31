import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobseekr/Service/UserService.dart';
import 'package:jobseekr/widget/Speedometer.dart';

class SearchAppearance extends StatefulWidget {
  const SearchAppearance({super.key});

  @override
  State<SearchAppearance> createState() => _SearchAppearanceState();
}

class _SearchAppearanceState extends State<SearchAppearance> {
  int profileViewCount = 0;

  initState() {
    super.initState();
    getProfileViews();
  }

  getProfileViews() async {
    UserService uservice = new UserService();
    List? profileViews = await uservice.getUserProfileViews();

    setState(() {
      profileViewCount = profileViews!.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(surfaceTintColor: Colors.white, elevation: 0),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Profile Performance",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("How your profile is performing among recruiters",
                        style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 245, 245, 245)),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "$profileViewCount search appearance in last 90 days"),
                            Text("38% more actions compare to last week",
                                style: TextStyle(color: Colors.blue))
                          ]),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Row(children: [
                            SvgPicture.asset(
                              "assets/zoom.svg",
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(width: 10),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("43 Searches by top compnaies!"),
                                  Text("Share interest to boost hiring chances",
                                      style: TextStyle(color: Colors.grey)),
                                ])
                          ]),
                          SizedBox(height: 20),
                          Container(
                              child: Column(children: [
                            Container(
                                color: Colors.white,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Image.network(
                                              "https://media.licdn.com/dms/image/C4D0BAQGA6s2gCDu-MA/company-logo_100_100/0/1630508225160/mphasis_logo?e=1726099200&v=beta&t=RjB7erQyoOqGd1bHI_wD6W-LkCXqVwcS9bTA6ifr2W0",
                                              height: 40,
                                              width: 40)),
                                      Container(
                                          padding: EdgeInsets.only(
                                              right: 20, top: 20, bottom: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Mphasis Software Engineer",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text("Pune, chennai",
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                              SizedBox(height: 10),
                                              Text(
                                                  "Searched: 'Android Developer'",
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              SizedBox(height: 10),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 239, 245, 250),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6),
                                                  child: Text("Share Interest",
                                                      style: TextStyle(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 0, 140, 255),
                                                          fontWeight:
                                                              FontWeight.bold)))
                                            ],
                                          ))
                                    ]))
                          ])),

                          SizedBox(height: 20),
                          Container(
                              child: Column(children: [
                            Container(
                                color: Colors.white,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Image.network(
                                              "https://media.licdn.com/dms/image/C4D0BAQGA6s2gCDu-MA/company-logo_100_100/0/1630508225160/mphasis_logo?e=1726099200&v=beta&t=RjB7erQyoOqGd1bHI_wD6W-LkCXqVwcS9bTA6ifr2W0",
                                              height: 40,
                                              width: 40)),
                                      Container(
                                          padding: EdgeInsets.only(
                                              right: 20, top: 20, bottom: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Mphasis Software Engineer",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text("Pune, chennai",
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                              SizedBox(height: 10),
                                              Text(
                                                  "Searched: 'Android Developer'",
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              SizedBox(height: 10),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 239, 245, 250),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6),
                                                  child: Text("Share Interest",
                                                      style: TextStyle(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 0, 140, 255),
                                                          fontWeight:
                                                              FontWeight.bold)))
                                            ],
                                          ))
                                    ]))
                          ])),

                          ///
                          ///
                          ///
                          //
                          SizedBox(height: 20),
                          Container(
                              child: Column(children: [
                            Container(
                                color: Colors.white,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Image.network(
                                              "https://media.licdn.com/dms/image/C4D0BAQGA6s2gCDu-MA/company-logo_100_100/0/1630508225160/mphasis_logo?e=1726099200&v=beta&t=RjB7erQyoOqGd1bHI_wD6W-LkCXqVwcS9bTA6ifr2W0",
                                              height: 40,
                                              width: 40)),
                                      Container(
                                          padding: EdgeInsets.only(
                                              right: 20, top: 20, bottom: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Mphasis Software Engineer",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text("Pune, chennai",
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                              SizedBox(height: 10),
                                              Text(
                                                  "Searched: 'Android Developer'",
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              SizedBox(height: 10),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 239, 245, 250),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6),
                                                  child: Text("Share Interest",
                                                      style: TextStyle(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 0, 140, 255),
                                                          fontWeight:
                                                              FontWeight.bold)))
                                            ],
                                          ))
                                    ]))
                          ]))

                          ///
                        ]))
                  ],
                ))));
  }
}
