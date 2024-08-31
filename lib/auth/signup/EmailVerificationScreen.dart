import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jobseekr/Service/AuthService.dart';
import 'package:jobseekr/auth/login/LoginEmailScreen.dart';
import 'package:jobseekr/auth/signup/BasicDetailsScreen.dart';
import 'package:jobseekr/onboarding/OnBoardingScreen.dart';
import 'package:jobseekr/themes/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EmailverificationScreen extends StatefulWidget {
  const EmailverificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailverificationScreen> createState() =>
      _EmailverificationScreenState();
}

class _EmailverificationScreenState extends State<EmailverificationScreen> {
  TextEditingController _otpController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, actions: [
        Padding(
          padding: EdgeInsets.only(right: 15, top: 10),
          child: GestureDetector(
              onTap: () async {
                AuthService auth = new AuthService();
                if (await auth.logout() == true) {
                  Navigator.push(
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
              'Verify your email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'A 6-digit code has been sent to your email. Please enter it within the next 30 minutes.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _otpController, // Add your controller here
              decoration: InputDecoration(
                hintText: 'Enter verification code',
                filled: true,
                fillColor: Color.fromARGB(255, 241, 240, 240),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // Remove underline border
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 16,
                ), // Adjust height here
                suffix: GestureDetector(
                  onTap: () {
                    // Implement resend code functionality here
                  },
                  child: Text(
                    'Resend Code',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                verifyEmail(_otpController.text);
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> verifyEmail(String otp) async {
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
        Uri.parse("https://api2.jobseekr.in/api/auth/verify/email"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'otp': otp}),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        bool isVerified = jsonDecode(response.body);
        if (isVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BasicDetailsScreen()),
          );

          // Perform additional actions after successful verification
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid OTP')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to verify email. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify email. Error: $e')),
      );
    }
  }
}
