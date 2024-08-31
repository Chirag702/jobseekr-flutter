import 'package:flutter/material.dart';
import 'package:jobseekr/Service/UserService.dart';
import 'package:jobseekr/pages/profile/ProfileScreen.dart';
import 'package:jobseekr/pages/profile/screens/Link2Screen.dart';
import 'package:jobseekr/pages/profile/screens/LinkScreen.dart';
import 'package:jobseekr/themes/styles.dart';
import 'package:jobseekr/widget/OutlineButton.dart';

class LinkWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  final VoidCallback refreshProfile; // Callback to refresh the profile screen

  const LinkWidget({
    required this.userData,
    required this.refreshProfile,
    Key? key,
  }) : super(key: key);
  @override
  State<LinkWidget> createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {
  // Callback function to refresh parent widget (ProfileScreen)

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Links",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          widget.userData?["link"] == null ||
                  widget.userData?["link"] == "" ||
                  (widget.userData?["link"] as List).isEmpty
              ? Container()
              : IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LinkScreen(
                                linkType: List<Map<String, dynamic>>.from(
                                    widget.userData?["link"]),
                              )),
                    );
                  },
                  icon: Icon(Icons.add))
        ]),
        SizedBox(height: 10),
        widget.userData?["link"] == null ||
                widget.userData?["link"] == "" ||
                (widget.userData?["link"] as List).isEmpty
            ? Text(
                "Portfolios on Github, Linkedin, etc. serves as a proof of work to thhe recruiters",
              )
            : Container(),
        widget.userData?["link"] == null ||
                widget.userData?["link"] == "" ||
                (widget.userData?["link"] as List).isEmpty
            ? Text(
                "Links contributes 15% to your profile",
              )
            : Container(),
        widget.userData?["link"] == null ||
                widget.userData?["link"] == "" ||
                (widget.userData?["link"] as List).isEmpty
            ? SizedBox(height: 20)
            : Container(),
        widget.userData?["link"] == null ||
                widget.userData?["link"] == "" ||
                (widget.userData?["link"] as List).isEmpty
            ? OutlineButton(
                title: "Add Link",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LinkScreen(
                              linkType: List<Map<String, dynamic>>.from(
                                  widget.userData?["link"]),
                            )),
                  );
                },
                hasIcon: true,
                icon: Icon(Icons.add),
              )
            : Column(
                children: (widget.userData?["link"] as List).map((link) {
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                link["type"] == "LinkedIn"
                                    ? Image.asset("assets/linkedin.png",
                                        height: 25, width: 25)
                                    : Container(),
                                link["type"] == "Facebook"
                                    ? Image.asset("assets/facebook.webp",
                                        height: 25, width: 25)
                                    : Container(),
                                link["type"] == "GitHub"
                                    ? Image.asset("assets/github.png",
                                        height: 25, width: 25)
                                    : Container(),
                                link["type"] == "Twitter"
                                    ? Image.asset("assets/twitter.png",
                                        height: 25, width: 25)
                                    : Container(),
                                SizedBox(width: 15),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(link["type"]),
                                      Text(
                                        link["url"].length > 29
                                            ? '${link["url"].substring(0, 29)}...' // truncate to 24 characters and add '...'
                                            : link[
                                                "url"], // use full text if less than or equal to 27 characters
                                        style: TextStyle(
                                          color: linkedInBlue0077B5,
                                          fontWeight: FontWeight.bold,
                                          // Add other styles as needed
                                        ),
                                      )
                                    ]),
                              ]),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return LinkModalContent(
                                        link["id"], link["type"], link["url"]);
                                  },
                                );
                              },
                              icon: Icon(Icons.more_vert_outlined))
                        ],
                      ));
                }).toList(), // Convert map result to a list
              ),
      ],
    );
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
