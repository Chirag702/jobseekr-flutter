import 'package:flutter/material.dart';

Navigation(screen, context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}
