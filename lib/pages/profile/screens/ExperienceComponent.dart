import 'package:flutter/material.dart';
import 'package:jobseekr/Service/UserService.dart';
import 'package:jobseekr/pages/profile/ProfileScreen.dart';

class ExperienceComponent extends StatefulWidget {
  final String? companyName;
  final String? from;
  final String? to;

  ExperienceComponent({
    this.companyName = "",
    this.from = "",
    this.to = "",
    Key? key,
  }) : super(key: key);

  @override
  _ExperienceComponentState createState() => _ExperienceComponentState();
}

class _ExperienceComponentState extends State<ExperienceComponent> {
  late TextEditingController _companyNameController;
  late TextEditingController _fromController;
  late TextEditingController _toController;
  late TextEditingController _descriptionController;
  late bool _isPresent = false;
  late String _selectedEmploymentType;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController(text: widget.companyName);
    _fromController = TextEditingController(text: widget.from);
    _toController = TextEditingController(text: widget.to);
    _descriptionController = TextEditingController();
    _selectedEmploymentType = 'Full Time';
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
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
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
                          'Add/Edit Experience',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Company Name',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _companyNameController,
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
                                    'From',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    controller: _fromController,
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
                                  ),
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
                                    'To',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    controller: _toController,
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
                                  ),
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
                                    _toController.clear();
                                  }
                                });
                              },
                            ),
                            Text('Present'),
                          ],
                        ),
                        Text(
                          'Employment Type',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 10),
                        DropdownButton<String>(
                          value: _selectedEmploymentType,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedEmploymentType = newValue!;
                            });
                          },
                          items: <String>[
                            'Full Time',
                            'Part Time',
                            'Self Employed',
                            'Freelance',
                            'Internship',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
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
                              "companyName": _companyNameController.text,
                              "from": _fromController.text,
                              "to": _isPresent ? "Present" : _toController.text,
                              "employmentType": _selectedEmploymentType,
                              "description": _descriptionController.text,
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ),
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
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
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
            ),
          ],
        ),
      ),
    );
  }
}
