import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobseekr/Service/UserService.dart';
import 'package:jobseekr/pages/profile/ProfileScreen.dart';

class CertificationScreen extends StatefulWidget {
  final List<Map<String, dynamic>> certification;
  const CertificationScreen({super.key, required this.certification});

  @override
  _CertificationScreenState createState() => _CertificationScreenState();
}

class _CertificationScreenState extends State<CertificationScreen> {
  var _dobController = TextEditingController();
  var _issueDateController = TextEditingController();
  var _expirationDateController = TextEditingController();

  DateTime? selectedDob;
  DateTime? selectedIssueDate;
  DateTime? selectedExpirationDate;

  bool isLoading = false;

  Future<void> _selectIssueDate(BuildContext context) async {
    final DateTime firstDate = DateTime(2015, 8);
    final DateTime initialDate = selectedIssueDate ?? firstDate;

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

    if (picked != null && picked != selectedIssueDate) {
      setState(() {
        selectedIssueDate = picked;
        _issueDateController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  Future<void> _selectExpirationDate(BuildContext context) async {
    final DateTime firstDate = DateTime(2015, 8);
    final DateTime initialDate = selectedExpirationDate ?? firstDate;

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

    if (picked != null && picked != selectedExpirationDate) {
      setState(() {
        selectedExpirationDate = picked;
        _expirationDateController.text =
            DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  String convertDateFormat(String date) {
    // Check if the date string is null or empty
    if (date == null || date.isEmpty) {
      throw FormatException('Invalid date string');
    }

    // Define the input and output date formats
    final DateFormat inputFormat = DateFormat('dd MMM yyyy');
    final DateFormat outputFormat = DateFormat('dd MMMM yyyy');

    // Parse the date string into a DateTime object
    DateTime dateTime;
    try {
      dateTime = inputFormat.parse(date);
    } catch (e) {
      throw FormatException('Error parsing date string: $date');
    }

    // Format the DateTime object into the desired output format
    return outputFormat.format(dateTime);
  }

  late TextEditingController _nameController;
  late TextEditingController _issuingOrganizationController;

  late TextEditingController _credentialIdController;
  late TextEditingController _credentialUrlController;
  late TextEditingController _descriptionController;
  late bool _isPresent = false;

  @override
  void initState() {
    super.initState();
    _dobController.text =
        DateFormat('dd MMM yyyy').format(DateTime(2002, 6, 9));
    selectedDob = DateTime(2002, 6, 9);

    // Initialize issue and expiration dates as needed
    _issueDateController = TextEditingController();

    _expirationDateController = TextEditingController();
    _nameController = TextEditingController();
    _issuingOrganizationController = TextEditingController();

    _credentialIdController = TextEditingController();
    _credentialUrlController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Certifications',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Issuing Organization',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _issuingOrganizationController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Issue Date',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                                onTap: () => _selectIssueDate(context),
                                child: AbsorbPointer(
                                    child: TextFormField(
                                  controller: _issueDateController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 16,
                                    ),
                                  ),
                                ))),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expiration Date',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                                onTap: () => _selectExpirationDate(context),
                                child: AbsorbPointer(
                                    child: TextFormField(
                                  controller: _expirationDateController,
                                  enabled: !_isPresent,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 16,
                                    ),
                                  ),
                                ))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        value: _isPresent,
                        onChanged: (value) {
                          setState(() {
                            _isPresent = value!;
                            if (value) {
                              _expirationDateController.clear();
                            }
                          });
                        },
                      ),
                      Text('Present'),
                    ],
                  ),
                  Text(
                    'Credential ID',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _credentialIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Credential URL',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _credentialUrlController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      UserService userService = UserService();
                      setState(() {
                        isLoading = true;
                      });
                      await userService.saveProfile({
                        "certification": [
                          {
                            "name": _nameController.text,
                            "issuingOrganization":
                                _issuingOrganizationController.text,
                            "issueDate": selectedIssueDate!.toIso8601String(),
                            "expirationDate": _isPresent
                                ? null
                                : selectedExpirationDate!.toIso8601String(),
                            "isPresent": _isPresent,
                            "credentialId": _credentialIdController.text,
                            "credentialUrl": _credentialUrlController.text,
                            "description": _descriptionController.text,
                          }
                        ]
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Color.fromRGBO(
                              252, 194, 4, 1); // Set background color
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
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      alignment: Alignment.center,
                      child: !isLoading
                          ? Text(
                              'Save',
                              style: TextStyle(color: Colors.black),
                            )
                          : SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.black),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
