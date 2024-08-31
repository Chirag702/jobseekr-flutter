import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jobseekr/MainScreen.dart';
import 'package:jobseekr/auth/signup/BasicDetailsScreen.dart';
import 'package:jobseekr/auth/signup/EmailVerificationScreen.dart';
import 'package:jobseekr/onboarding/OnBoardingScreen.dart';
import 'package:http/http.dart' as http;
import 'package:jobseekr/pages/profile/DeleteProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  Future<void> initUniLinks() async {
    // Listen for incoming deep links
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleDeepLink(uri);
      }
    }, onError: (Object err) {
      print('Error handling deep link: $err');
    });

    // Handle initial deep link when app starts from a link
    final initialLink = await getInitialUri();
    if (initialLink != null) {
      handleDeepLink(initialLink);
    }
  }

  void handleDeepLink(Uri uri) {
    print('Received deep link: $uri');

    // Example: Navigate to appropriate screen based on the deep link path
    if (uri.path == '/dashboard') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => DeleteProfileScreen()));
    } else {
      print('Unsupported deep link: $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<Map<String, dynamic>>(
          future: fetchAllData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: Colors.white, // Ensure the background is white
                body: Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                backgroundColor: Colors.white, // Ensure the background is white
                body: Center(child: Text('Error: ${snapshot.error}')),
              );
            } else {
              final data = snapshot.data!;
              if (!data['isSignedIn']) {
                return OnBoardingScreen();
              } else if (!data['isVerified']) {
                return EmailverificationScreen();
              } else {
                return data['hasInitialProfile']
                    ? BasicDetailsScreen()
                    : MainScreen(1);
              }
            }
          },
        ));
  }
}

Future<Map<String, dynamic>> fetchAllData() async {
  bool isSignedIn = await checkUserSignIn();
  if (!isSignedIn) {
    return {'isSignedIn': false};
  }

  bool isVerified = await isEmailVerified();
  if (!isVerified) {
    return {'isSignedIn': true, 'isVerified': false};
  }

  bool hasInitialProfile = await isInitialProfileExists();
  return {
    'isSignedIn': true,
    'isVerified': true,
    'hasInitialProfile': hasInitialProfile,
  };
}

Future<bool> checkUserSignIn() async {
  // Retrieve user sign-in status from local storage
  final isLoggedIn = await getSignInStatus();
  return isLoggedIn;
}

Future<bool> getSignInStatus() async {
  final prefs = await SharedPreferences.getInstance();
  // Retrieve the sign-in status from local storage
  final bool? isLoggedIn = prefs.getBool('isLoggedIn');
  return isLoggedIn ?? false; // Return false if sign-in status is null
}

Future<bool> isEmailVerified() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs
      .getString('token')
      ?.replaceAll(" ", ""); // Use null check operator '?'
  print('Token: $token');

  try {
    final response = await http.post(
      Uri.parse("https://api2.jobseekr.in/api/auth/is/email/verify"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return response.body == 'true'; // Return the result, or false if null
    } else {
      // Handle other status codes if needed
      return false;
    }
  } catch (e) {
    print('Error verifying email: $e');
    return false; // Return false in case of error
  }
}

Future<bool> isInitialProfileExists() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token')?.replaceAll(" ", "");

  try {
    final response = await http.get(
      Uri.parse("https://api2.jobseekr.in/api/user/profile"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Decode the response body
      final Map<String, dynamic> data;
      try {
        data = json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        print('Error decoding JSON: $e');
        return false; // Return false if JSON decoding fails
      }

      // Extract the first name from the response
      final String? fname = data['fname'];
      print("fname : $fname");
      // Check if fname is null or empty
      if (fname == null || fname.isEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      // Handle other status codes if needed
      print('Request failed with status: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error verifying profile: $e');
    return false; // Return false in case of error
  }
}
