import 'package:flutter/material.dart';
import 'package:jobseekr/themes/styles.dart';

class LoginButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String title;
  final VoidCallback? onTap;
  final bool? hasIcon;
  final Widget? icon;
  const LoginButton(
      {Key? key,
      this.width = double.infinity,
      this.height = 40,
      required this.title,
      this.onTap,
      this.hasIcon = false,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: hasIcon == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon!,
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Text(
                  title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
