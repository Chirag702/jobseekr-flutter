import 'package:flutter/material.dart';
import 'package:jobseekr/MainScreen.dart';
import 'package:jobseekr/Service/UserService.dart';
import 'package:jobseekr/pages/profile/ProfileScreen.dart';

class AboutComponent extends StatefulWidget {
  final String? userData;

  AboutComponent({this.userData = "", Key? key}) : super(key: key);

  @override
  _AboutComponentState createState() => _AboutComponentState();
}

class _AboutComponentState extends State<AboutComponent> {
  late TextEditingController _aboutController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _aboutController = TextEditingController(text: widget.userData);
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
                          'About',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Write about yourself',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _aboutController,
                              maxLength: 100,
                              maxLines:
                                  7, // Set the maximum number of lines to 7
                              decoration: InputDecoration(
                                hintText: 'Add description',
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
                              'Summary contibutes 10% to your profile',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                UserService userService = new UserService();
                                setState(() {
                                  isLoading = true;
                                });
                                await userService.saveProfile(
                                    {"about": _aboutController.text});
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(2),
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
