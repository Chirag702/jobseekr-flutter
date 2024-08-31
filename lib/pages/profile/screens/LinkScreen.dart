import 'package:flutter/material.dart';
import 'package:jobseekr/Service/UserService.dart';
import 'package:jobseekr/pages/profile/ProfileScreen.dart';

class LinkScreen extends StatefulWidget {
  final List<Map<String, dynamic>> linkType;
  const LinkScreen({Key? key, required this.linkType}) : super(key: key);

  @override
  State<LinkScreen> createState() => _LinkScreenState();
}

class _LinkScreenState extends State<LinkScreen> {
  var _linkController = TextEditingController();
  bool isLoading = false;
  String? _selectedOption;

  List<String> _options = ['LinkedIn', 'Facebook', 'GitHub', 'Twitter'];

  @override
  void initState() {
    super.initState();
    try {
      print("Links: " + widget.linkType.toString());
    } catch (ex) {
      print(ex);
    }
    // Filter the options based on existing link types
    _filterOptions();
  }

  void _filterOptions() {
    List<String> existingTypes =
        widget.linkType.map((link) => link['type'].toString()).toList();
    _options =
        _options.where((option) => !existingTypes.contains(option)).toList();
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
                              'Add Links',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Type',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonFormField<String>(
                                  value: _selectedOption,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedOption = newValue;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Select your platform',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 16,
                                    ),
                                  ),
                                  items: _options.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Url',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: _linkController,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
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
                                        // Validate URL format based on selected option
                                        bool isValid = isValidUrl(
                                            _linkController.text.trim(),
                                            _selectedOption!);

                                        // Show Snackbar for invalid URL format
                                        if (!isValid) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  '$_selectedOption URL is invalid'),
                                              duration: Duration(
                                                  seconds:
                                                      3), // Adjust duration as needed
                                              action: SnackBarAction(
                                                label: 'OK',
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                },
                                              ),
                                            ),
                                          );
                                          return; // Prevent further execution
                                        }

                                        // Continue with save logic or navigation
                                        await userService.saveProfile({
                                          "link": [
                                            {
                                              "type": _selectedOption,
                                              "url": _linkController.text
                                            }
                                          ]
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
                          ]))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidUrl(String url, String type) {
    switch (type) {
      case 'LinkedIn':
        return url.startsWith("https://www.linkedin.com/");
      case 'Facebook':
        // Example Facebook URL validation (customize as per Facebook URL format)
        return url.startsWith("https://www.facebook.com/");
      case 'GitHub':
        // Example GitHub URL validation (customize as per GitHub URL format)
        return url.startsWith("https://github.com/");
      case 'Twitter':
        // Example Twitter URL validation (customize as per Twitter URL format)
        return url.startsWith("https://twitter.com/");
      default:
        return false; // Default case: invalid URL for unknown type
    }
  }
}
