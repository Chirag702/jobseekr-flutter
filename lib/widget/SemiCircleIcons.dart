import 'dart:math' as math;

import 'package:flutter/material.dart';

class SemicircleIcons extends StatelessWidget {
  final List<Widget> icons;

  SemicircleIcons({required this.icons});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // This Stack widget aligns the icons at the center
        Stack(
          children: icons.asMap().entries.map((entry) {
            final index = entry.key;
            final angle = math.pi / (icons.length - 1) * index;
            final radius = 130.0; // Radius of the semicircle

            return Transform.translate(
                offset: Offset(
                  math.cos(angle) * radius,
                  -math.sin(angle) * radius, // Offset for each icon
                ),
                child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: entry.value, // Actual icon widget
                    )));
          }).toList(),
        ),
        // Container to hold the text at the bottom
        Center(
          child: Container(
            child: Text(
              '150+ companies', // Text to display
              // Text style
            ),
          ),
        )
      ],
    );
  }
}
