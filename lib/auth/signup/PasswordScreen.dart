import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobseekr/auth/signup/EmailScreen.dart';
import 'package:jobseekr/auth/signup/EmailVerificationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordScreen extends StatefulWidget {
  final String email;

  const PasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  // Password strength indicators
  bool _isPasswordLengthValid = false;
  bool _isPasswordContainsNumber = false;
  bool _isPasswordContainsUppercase = false;

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
                  onChanged: (value) {
                    setState(() {
                      // Password length validation
                      _isPasswordLengthValid = value.length >= 8;
                      // Check if password contains number
                      _isPasswordContainsNumber = RegExp(r'\d').hasMatch(value);
                      // Check if password contains uppercase
                      _isPasswordContainsUppercase =
                          value.contains(RegExp(r'[A-Z]'));
                    });
                  },
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
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.check,
                        color:
                            _isPasswordLengthValid ? Colors.green : Colors.grey,
                        size: 15),
                    SizedBox(width: 10),
                    Text('At least 8 characters'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.check,
                        color: _isPasswordContainsNumber
                            ? Colors.green
                            : Colors.grey,
                        size: 15),
                    SizedBox(width: 10),
                    Text('At least one number'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.check,
                        color: _isPasswordContainsUppercase
                            ? Colors.green
                            : Colors.grey,
                        size: 15),
                    SizedBox(width: 10),
                    Text('At least one uppercase'),
                  ],
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
    if (_isPasswordLengthValid &&
        _isPasswordContainsNumber &&
        _isPasswordContainsUppercase) {
      setState(() {
        isLoading = true;
      });

      String apiUrl = 'https://api2.jobseekr.in/api/auth/signup';

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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EmailverificationScreen()),
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
}
