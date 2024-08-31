import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jobseekr/auth/login/LoginPasswordScreen.dart';
import 'package:jobseekr/auth/signup/EmailScreen.dart';
import 'package:jobseekr/onboarding/OnBoardingScreen.dart';
import 'package:jobseekr/themes/styles.dart';
import 'package:http/http.dart' as http;

class LoginEmailScreen extends StatefulWidget {
  const LoginEmailScreen({super.key});

  @override
  State<LoginEmailScreen> createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  bool _emailExists = false;

  bool isLoading = false;

  TextEditingController _emailController = TextEditingController();

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
        if (response.body == "false") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account with email doesn\'t exists')),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginPasswordScreen(email: _emailController.text)),
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
            TextFormField(
              cursorColor: Colors.black,
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
                  MaterialPageRoute(builder: (context) => EmailScreen()),
                );
              },
              child: Text(
                'Create a jobseekr account',
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
