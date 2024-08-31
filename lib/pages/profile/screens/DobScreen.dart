import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobseekr/Service/UserService.dart';
import 'package:jobseekr/pages/profile/ProfileScreen.dart';
import 'package:jobseekr/themes/styles.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class DobScreen extends StatefulWidget {
  const DobScreen({Key? key});

  @override
  State<DobScreen> createState() => _DobScreenState();
}

class _DobScreenState extends State<DobScreen> {
  var _dobController = TextEditingController();
  DateTime? selectedDate;

  bool isLoading = false; // Make selectedDate nullable

  @override
  void initState() {
    super.initState();
    _dobController.text =
        DateFormat('dd MMMM yyyy').format(DateTime(2002, 6, 9));
    selectedDate = DateTime(2002, 6, 9); // Initialize selectedDate
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime firstDate = DateTime(2015, 8);
    final DateTime initialDate =
        selectedDate != null && selectedDate!.isAfter(firstDate)
            ? selectedDate!
            : firstDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFA19100),
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: Colors.red,
                  ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _dobController.text = DateFormat('dd MMMM yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add your Birth date',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Birth date',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _dobController,
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(115, 224, 222, 222),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 16),
                            suffixIcon: Icon(
                                Icons.arrow_drop_down), // Chevron down icon
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'We will send the OTP to your number. Please verify your phone by entering the OTP',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              UserService userService = new UserService();
                              await userService.saveProfile(
                                  {"dob": selectedDate!.toIso8601String()});
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen()),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return Color.fromRGBO(
                                      252, 194, 4, 1); // Set background color
                                },
                              ),
                              shape: MaterialStateProperty.resolveWith<
                                  OutlinedBorder>(
                                (Set<MaterialState> states) {
                                  return RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Set border radius
                                  );
                                },
                              ),
                            ),
                            child: Container(
                                width:
                                    double.infinity, // Make button full width
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                alignment: Alignment.center,
                                child: !isLoading
                                    ? Text(
                                        'Next',
                                        style: TextStyle(color: Colors.black),
                                      )
                                    : SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            color: Colors.black),
                                      )),
                          ),
                        ])
                  ]))
        ],
      ),
    );
  }
}
