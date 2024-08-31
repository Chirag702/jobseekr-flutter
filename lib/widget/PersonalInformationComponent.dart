import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobseekr/pages/profile/screens/DobScreen.dart';
import 'package:jobseekr/pages/profile/screens/PhoneScreen.dart';
import 'package:provider/provider.dart';

class PersonalInformationComponent extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PersonalInformationComponent(this.userData, {Key? key});

  @override
  State<PersonalInformationComponent> createState() =>
      _PersonalInformationComponentState();
}

class _PersonalInformationComponentState
    extends State<PersonalInformationComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("Personal Information",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Icon(Icons.lock_outline, size: 16, color: Colors.grey),
            SizedBox(width: 10),
            Text("Private to you", style: TextStyle(color: Colors.grey))
          ],
        )
      ]),
      SizedBox(height: 20),
      Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (widget.userData["phone"] == "" ||
                      widget.userData["phone"] == null)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Phone",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            )),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhoneScreen()),
                              );
                            },
                            icon: Icon(Icons.add)),
                      ],
                    )
                  : Row(
                      children: [
                        Text("Phone",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            )),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(Icons.circle, size: 5),
                            SizedBox(width: 10),
                            (widget.userData["isPhoneVerified"] == 0 ||
                                    widget.userData["isPhoneVerified"] == null)
                                ? Text("verify phone number",
                                    style: TextStyle(color: Colors.blue))
                                : Text("verified",
                                    style: TextStyle(color: Colors.blue))
                          ],
                        )
                      ],
                    ),
              (widget.userData["phone"] == "" ||
                      widget.userData["phone"] == null)
                  ? Text("Add your phone")
                  : Text(widget.userData["phone"]),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Birthday",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      )),
                  ((widget.userData["dob"] == "" ||
                          widget.userData["dob"] == null))
                      ? IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return DobScreen();
                              },
                            );
                          },
                          icon: Icon(Icons.add))
                      : Container()
                ],
              ),
              SizedBox(height: 5),
              (widget.userData["dob"] == "" || widget.userData["dob"] == null)
                  ? Text("Add your birthday")
                  : Text(DateFormat('dd MMMM yyyy')
                      .format(DateTime.parse(widget.userData["dob"]))),
              SizedBox(height: 20),
              (widget.userData["email"] == "" ||
                      widget.userData["email"] == null)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Email",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            )),
                        Icon(Icons.add),
                      ],
                    )
                  : Row(
                      children: [
                        Text("Email",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            )),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(Icons.circle, size: 5),
                            SizedBox(width: 10),
                            (widget.userData["isEmailVerified"] == 0 ||
                                    widget.userData["isEmailVerified"] == null)
                                ? Text("verify email",
                                    style: TextStyle(color: Colors.blue))
                                : Text("verified",
                                    style: TextStyle(color: Colors.blue))
                          ],
                        )
                      ],
                    ),
              SizedBox(height: 5),
              (widget.userData["email"] == "" ||
                      widget.userData["email"] == null)
                  ? Text("Add your email")
                  : Text(widget.userData["email"]),
            ],
          ))
    ]);
  }
}
