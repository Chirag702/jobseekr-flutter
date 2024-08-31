import 'package:flutter/material.dart';
import 'package:jobseekr/Service/UserService.dart';
import 'package:jobseekr/pages/profile/ProfileScreen.dart';

class NameComponent extends StatefulWidget {
  final String fname;
  final String lname;

  NameComponent({required this.fname, required this.lname, Key? key})
      : super(key: key);

  @override
  _NameComponentState createState() => _NameComponentState();
}

class _NameComponentState extends State<NameComponent> {
  late TextEditingController _fnameController;
  late TextEditingController _lnameController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fnameController = TextEditingController(text: widget.fname);
    _lnameController = TextEditingController(text: widget.lname);
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
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Details',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'First name',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _fnameController,
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
                                SizedBox(height: 20),
                                Text(
                                  'Last name',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: _lnameController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: Colors.black),
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
                                        UserService userService =
                                            new UserService();
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await userService.saveProfile({
                                          "fname": _fnameController.text,
                                          "lname": _lnameController.text
                                        });
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileScreen(),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            return Color.fromRGBO(252, 194, 4,
                                                1); // Set background color
                                          },
                                        ),
                                        shape: MaterialStateProperty
                                            .resolveWith<OutlinedBorder>(
                                          (Set<MaterialState> states) {
                                            return RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            : SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors.black),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
