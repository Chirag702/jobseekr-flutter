import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobseekr/auth/signup/EmailScreen.dart';
import 'package:jobseekr/auth/signup/EmailVerificationScreen.dart';
import 'package:jobseekr/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPasswordScreen extends StatefulWidget {
  final String email;

  const LoginPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<LoginPasswordScreen> createState() => _LoginPasswordScreenState();
}

class _LoginPasswordScreenState extends State<LoginPasswordScreen> {
  TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmailScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Password',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    filled: true,
                    fillColor: Color.fromARGB(255, 241, 240, 240),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: !isLoading ? createUser : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.black;
                  },
                ),
                shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                  (Set<MaterialState> states) {
                    return RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    );
                  },
                ),
              ),
              child: Container(
                width: double.infinity,
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
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmailScreen()),
                    );
                  },
                  child: Text(
                    'Forgot password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _extractToken(String? cookie) {
    if (cookie == null) {
      return ''; // Return empty string if cookie is null
    }
    // Split cookie by ';' to separate parts
    final parts = cookie.split(';');
    // Find the part containing the 'jobseekr' cookie
    String? jobseekrCookiePart;
    try {
      jobseekrCookiePart =
          parts.firstWhere((part) => part.trim().startsWith('jobseekr='));
    } catch (e) {
      jobseekrCookiePart = null;
    }
    if (jobseekrCookiePart == null) {
      return ''; // Return empty string if 'jobseekr' cookie part is not found
    }
    // Extract the value of the 'jobseekr' cookie
    final jobseekrCookieValue =
        jobseekrCookiePart.trim().substring('jobseekr='.length);
    return jobseekrCookieValue;
  }

  Future<void> createUser() async {
    setState(() {
      isLoading = true;
    });

    String apiUrl = 'https://api2.jobseekr.in/api/auth/signin';

    // Data to be sent
    Map<String, dynamic> data = {
      'username': widget.email,
      'email': widget.email,
      'password': _passwordController.text,
    };

    // Encode the data to JSON
    String jsonData = jsonEncode(data);

    try {
      // Make POST request
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      // Check if request is successful
      if (response.statusCode == 200) {
        // If successful, do something with the response
        print('Data posted successfully');
        print('Response: ${response.body}');
        final cookie = response.headers['set-cookie'];
        final jobseekrCookieValue = _extractToken(cookie);
        print('Jobseekr Cookie: $jobseekrCookieValue');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        await prefs.setString("token", jobseekrCookieValue);
        await prefs.setBool("isLoggedIn", true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
          (route) => false,
        );
      } else {
        // If request is not successful, handle the error
        print('Failed to post data');
        print('Response: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any errors that occur during the request
      print('Error posting data: $e');
    }
    setState(() {
      isLoading = false;
    });
  }
}
