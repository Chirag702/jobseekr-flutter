import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobseekr/pages/invite/Invite.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String firstName;
  final String lastName;
  final int pageIndex;
  final String companyName;
  final PreferredSizeWidget? bottom;

  const CustomAppBar(
      {Key? key,
      required this.firstName,
      required this.lastName,
      required this.companyName,
      required this.pageIndex,
      this.bottom // Default value for bottom
      })
      : super(key: key);

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    String initials = '';
    if (firstName.isNotEmpty) {
      initials += firstName[0];
    }
    if (lastName.isNotEmpty) {
      initials += lastName[0];
    }

    return AppBar(
      bottom: bottom,
      elevation: 0,
      automaticallyImplyLeading: pageIndex == 1 ? true : false,
      iconTheme: IconThemeData(color: Colors.black),
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      title: pageIndex == 1
          ? Text("My Applications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          : Row(
              mainAxisAlignment: MainAxisAlignment.start, // Center horizontally
              children: [
                if (initials
                    .isNotEmpty) // Check if initials are not empty before displaying
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      initials.toUpperCase(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (firstName.isNotEmpty &&
                        lastName
                            .isNotEmpty) // Check if names are not empty before displaying
                      Text(
                        '${firstName[0].toUpperCase()}${firstName.substring(1).toLowerCase()} ${lastName[0].toUpperCase()}${lastName.substring(1).toLowerCase()}',
                        style: TextStyle(fontSize: 16),
                      ),
                    Text(
                      companyName,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
      actions: [
        //   pageIndex == 1
        //       ? IconButton(
        //           onPressed: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(builder: (context) => Invite()),
        //             );
        //           },
        //           icon: Icon(FontAwesomeIcons.questionCircle, size: 20),
        //         )
        //       : Container(),
        pageIndex == 0
            ? IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Invite()),
                  );
                },
                icon: Icon(FontAwesomeIcons.gift, size: 20),
              )
            : Container()
        //       : pageIndex == 2
        //           ? IconButton(
        //               onPressed: () {},
        //               icon: Icon(Icons.share_outlined),
        //             )
        //           : Container(),
        //   pageIndex == 2 || pageIndex == 0
        //       ? IconButton(
        //           onPressed: () {},
        //           icon: Icon(Icons.notifications_outlined),
        //         )
        //       : Container(),
        //   pageIndex == 0
        //       ? IconButton(
        //           onPressed: () {},
        //           icon: Icon(FontAwesomeIcons.message, size: 20),
        //         )
        //       : pageIndex == 2
        //           ? IconButton(
        //               onPressed: () {},
        //               icon: Icon(Icons.more_vert),
        //             )
        //           : Container(),
      ],
    );
  }
}
