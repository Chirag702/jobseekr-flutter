import 'package:flutter/material.dart';

class Tags extends StatefulWidget {
  final String title;
  final double? fontSize;

  const Tags({Key? key, required this.title, this.fontSize = 15})
      : super(key: key);
  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 5, left: 10, bottom: 5),
        child: Material(
          borderRadius: BorderRadius.circular(50),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                // Add onTap functionality if needed
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 10),
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: widget.fontSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
