import 'package:flutter/material.dart';

ProfileStatus(context, profilePic, initials, Map<String, dynamic>? userProfile,
    {required Null Function() ontap,
    required title,
    required String subTitle,
    required String buttonTitle,
    required Color backgroundColor}) {
  return GestureDetector(
      onTap: ontap,
      child: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Card(
                color: backgroundColor,
                elevation: 0.05, // Small shadow
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      profilePic == null
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: backgroundColor.withOpacity(
                                      0.5), // Add your desired border color here
                                  width: 3, // Adjust the border width as needed
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      10), // Adjust padding as needed
                                  child: Text(
                                    initials.toUpperCase(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                profilePic, // Replace with your image path
                              ),
                            ),
                      SizedBox(width: 10), // Space between image and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            subTitle,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            buttonTitle,
                            style: TextStyle(
                                fontSize: 12, color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ))));
}
