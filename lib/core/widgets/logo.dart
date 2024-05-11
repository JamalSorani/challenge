import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo(
      {super.key,
      required this.width,
      required this.height,
      required this.color});
  final double width;
  final double height;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: width,
      height: height,
      color: color,
    );
  }
}
