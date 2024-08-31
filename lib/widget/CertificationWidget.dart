import 'package:flutter/material.dart';
import 'package:jobseekr/Service/UserService.dart';
import 'package:jobseekr/pages/profile/screens/CertificationScreen.dart';
import 'package:jobseekr/pages/profile/screens/Link2Screen.dart';
import 'package:jobseekr/widget/OutlineButton.dart';

class CertificationWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  final VoidCallback refreshProfile; // Callback to refresh the profile screen
  const CertificationWidget({
    required this.userData,
    required this.refreshProfile,
    Key? key,
  });

  @override
  State<CertificationWidget> createState() => _CertificationWidgetState();
}

class _CertificationWidgetState extends State<CertificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 20),
      Row(children: [
        Text("Certifications & licence",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        widget.userData?["certification"] == null ||
                widget.userData?["certification"] == "" ||
                (widget.userData?["certification"] as List).isEmpty
            ? Container()
            : IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CertificationScreen(
                              certification: List<Map<String, dynamic>>.from(
                                  widget.userData?["certification"]),
                            )),
                  );
                },
                icon: Icon(Icons.add))
      ]),
      SizedBox(height: 10),
      widget.userData?["certification"] == null ||
              widget.userData?["certification"] == "" ||
              (widget.userData?["certification"] as List).isEmpty
          ? Text(
              "Showcase your credibility and gain an edge in the competitive job market.",
            )
          : Container(),
      widget.userData?["certification"] == null ||
              widget.userData?["certification"] == "" ||
              (widget.userData?["certification"] as List).isEmpty
          ? SizedBox(height: 20)
          : Container(),
      widget.userData?["certification"] == null ||
              widget.userData?["certification"] == "" ||
              (widget.userData?["certification"] as List).isEmpty
          ? OutlineButton(
              title: "Add Certification",
              hasIcon: true,
              icon: Icon(Icons.add),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CertificationScreen(
                      certification: List<Map<String, dynamic>>.from(
                          widget.userData?["certification"]),
                    ),
                  ),
                );
              },
            )
          : Column(
              children: (widget.userData?["certification"] as List)
                  .map((certification) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16.0),
                          color: Colors.blueGrey[50],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    certification["issuingOrganization"],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    certification["name"] ??
                                        'Title Not Available',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 20, top: 20),
                                        child: Text(
                                          "Credential ID: ${certification["credentialId"]}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 20, top: 4),
                                        child: Text(
                                          certification["credentialUrl"],
                                          style: TextStyle(fontSize: 12),
                                        ))
                                  ]),
                              IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return LinkModalContent(1, "", "");
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.more_vert_outlined))
                            ])
                      ],
                    ));
              }).toList(),
            ),
    ]); //
  }

  Widget LinkModalContent(id, type, url) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Edit'),
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Link2Screen(
                          type: type,
                          url: url,
                          id: id,
                        )),
              );
            },
          ),
          ListTile(
            title: Text('Delete'),
            leading: Icon(Icons.delete),
            onTap: () async {
              UserService uservice = new UserService();
              await uservice.deleteProfileLinks(id);
              Navigator.pop(context);
              widget
                  .refreshProfile(); // Call the callback to refresh the profile screen
            },
          ),

          // Add more ListTiles for additional actions as needed
        ],
      ),
    );
  }
}
