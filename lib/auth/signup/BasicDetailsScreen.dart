import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jobseekr/MainScreen.dart';
import 'package:jobseekr/Service/AuthService.dart';
import 'package:jobseekr/onboarding/OnBoardingScreen.dart';
import 'package:jobseekr/pages/jobs/JobsScreen.dart';
import 'package:jobseekr/pages/profile/ProfileScreen.dart';
import 'package:jobseekr/themes/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BasicDetailsScreen extends StatefulWidget {
  const BasicDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends State<BasicDetailsScreen> {
  String selectedGender = "";

  bool isLoading = false;

  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();

  Future<void> saveInitialProfile(
      String fname, String lname, String gender) async {
    setState(() => isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = (prefs.getString('token'))!.replaceAll(" ", "");

    print('Token: $token');
    if (token == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token not found')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("https://api2.jobseekr.in/api/user/init/profile"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"fname": fname, "lname": lname, "gender": gender}),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        print(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(1)),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: EdgeInsets.only(right: 15, top: 10),
          child: GestureDetector(
              onTap: () async {
                AuthService auth = new AuthService();
                if (await auth.logout() == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OnBoardingScreen()),
                  );
                }
              },
              child: Text("Logout",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create your profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'First name',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 50, // Set a fixed height for TextFormField
                  child: TextFormField(
                    controller: _fnameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your first name',
                      filled: true,
                      fillColor: Color.fromARGB(255, 241, 240, 240),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),

                //
                //
                //
                //
                SizedBox(height: 10),
                Text(
                  'Last name',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 50, // Set a fixed height for TextFormField
                  child: TextFormField(
                    controller: _lnameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your last name',
                      filled: true,
                      fillColor: Color.fromARGB(255, 241, 240, 240),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = 'Male'; // Set selected gender to Male
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      decoration: BoxDecoration(
                        color: selectedGender == 'Male'
                            ? Colors.black
                            : Color.fromARGB(255, 241, 240, 240),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Male',
                        style: TextStyle(
                            color: selectedGender == 'Male'
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender =
                            'Female'; // Set selected gender to Female
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      decoration: BoxDecoration(
                        color: selectedGender == 'Female'
                            ? Colors.black
                            : Color.fromARGB(255, 241, 240, 240),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Female',
                        style: TextStyle(
                            color: selectedGender == 'Female'
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ])
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_fnameController.text == null ||
                    _lnameController.text == null ||
                    selectedGender == null ||
                    _fnameController.text == "" ||
                    _lnameController.text == "" ||
                    selectedGender == "" ||
                    isLoading) {
                } else {
                  try {
                    await saveInitialProfile(_fnameController.text,
                        _lnameController.text, selectedGender);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen(1)),
                    );
                  } catch (ex) {}
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.black; // Set background color
                  },
                ),
                shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                  (Set<MaterialState> states) {
                    return RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Set border radius
                    );
                  },
                ),
              ),
              child: Container(
                  width: double.infinity, // Make button full width
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  alignment: Alignment.center,
                  child: !isLoading
                      ? Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        )
                      : SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
