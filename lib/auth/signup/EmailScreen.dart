import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jobseekr/auth/login/LoginEmailScreen.dart';
import 'package:jobseekr/auth/signup/EmailVerificationScreen.dart';
import 'package:jobseekr/auth/signup/PasswordScreen.dart';
import 'package:jobseekr/onboarding/OnBoardingScreen.dart';
import 'package:http/http.dart' as http;

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  TextEditingController _emailController = TextEditingController();
  bool _emailExists = false;

  bool isLoading = false;

  String emailError = "";
  Future<void> checkEmailExists() async {
    setState(() => {isLoading = true});

    // Validate email format using RegExp
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(_emailController.text)) {
      // Email format is invalid
      setState(
          () => {isLoading = false, emailError = "Please enter a valid email"});
    } else {
      // Email format is valid, proceed with checking email existence
      final response = await http.post(
        Uri.parse('https://api2.jobseekr.in/api/auth/check/email'),
        body: jsonEncode({'email': _emailController.text}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        if (response.body == "false") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PasswordScreen(email: _emailController.text)),
          );
        }
        setState(() {
          _emailExists = (response.body == 'true');
        });
      } else {
        // Handle error
        print('Failed to check email existence');
      }
      setState(() => {isLoading = false});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OnBoardingScreen()),
            );

            // Implement close action here
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Jobseekr',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Email/Username',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController, // Add your controller here
                  decoration: InputDecoration(
                    hintText: 'Enter your email or username',
                    filled: true,
                    fillColor: Color.fromARGB(255, 241, 240, 240),

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Set border radius here
                      borderSide: BorderSide.none, // Remove underline border
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 15, horizontal: 16), // Adjust height here
                  ),
                ),
                if (_emailExists) // Check if email exists
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Text(
                      'The account already exists. Please login.',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                if (emailError != "")
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Text(
                      emailError,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'By creating an account, I agree to Jobseekr\'s Terms of Service and Privacy Policy',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                !isLoading ? checkEmailExists() : null;
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginEmailScreen()),
                );
              },
              child: Text(
                'Have an account? Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
