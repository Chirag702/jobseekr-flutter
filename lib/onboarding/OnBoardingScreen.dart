import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobseekr/auth/login/LoginEmailScreen.dart';
import 'package:jobseekr/auth/signup/EmailScreen.dart';

import 'package:jobseekr/themes/styles.dart';
import 'package:jobseekr/widget/LoginButton.dart';
import 'package:jobseekr/widget/SemiCircleIcons.dart';
import 'package:jobseekr/widget/Tags.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Text(
                    "Jobseekr",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Join a trusted community of 1000+ professionals",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: linkedInMediumGrey86888A, fontSize: 16),
                  )
                ],
              ),
            ),
            SizedBox(height: 100),
            Center(
              child: SemicircleIcons(
                icons: [
                  Image.asset("assets/airbnb.png"),
                  Image.asset("assets/slack.png"),
                  Image.asset("assets/paypal.png"),
                  Image.asset("assets/digitalocean.png"),
                  Image.asset("assets/amazon.png"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: linkedInLightGreyCACCCE,
                    spreadRadius: 0.05,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Expected CTC"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "₹ 42 ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text("LPA", style: TextStyle(fontSize: 16)),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Location"),
                            Text(
                              "WFH, Delhi",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double
                        .infinity, // Ensure the container takes full width
                    child: Wrap(
                      children: [
                        Tags(title: "Company"),
                        Tags(title: "Industry"),
                        Tags(title: "Role"),
                        Tags(title: "Benefits"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isLoading ? _loadingButton() : _googleSignInButton(),
    );
  }

  Widget _loadingButton() {
    return Container(
      margin: EdgeInsets.all(20),
      child: LoginButton(
        onTap: () {},
        icon: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
        title: '',
      ),
    );
  }

  Widget _googleSignInButton() {
    return Container(
      margin: EdgeInsets.all(20),
      child: LoginButton(
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginEmailScreen()),
          );

          setState(() {
            isLoading = false;
          });
        },
        title: "Continue",
      ),
    );
  }
}
