import 'package:flutter/material.dart';
import 'package:jobseekr/Service/CompanyService.dart';
import 'package:jobseekr/Service/UserService.dart';
import 'package:jobseekr/widget/CustomAppBar.dart';
import 'package:jobseekr/widget/SavedJobCard.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({Key? key}) : super(key: key); // Fix key parameter

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  String? profilePic;

  bool isLoading = false;

  Map<String, dynamic>? userProfile = {};

  List<Map<String, dynamic>>? companyData = [];

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
              pageIndex: 1,
            ),
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    ])),
          )
        : Scaffold(
            appBar: CustomAppBar(
              firstName: userProfile?["fname"] ?? "",
              lastName: userProfile?["lname"] ?? "",
              companyName: 'JobSeekr',
              pageIndex: 1,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SavedJobCard(),
                ],
              ),
            ),
          );
  }
}
