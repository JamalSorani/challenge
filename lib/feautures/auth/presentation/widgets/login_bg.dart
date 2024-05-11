import 'package:flutter/material.dart';

import '../../../../core/widgets/logo.dart';

class LoginBg extends StatelessWidget {
  const LoginBg({super.key, required this.withBackArrow});
  final bool withBackArrow;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: withBackArrow ? height * 0.18 - 80 : height * 0.18,
          child: Image.asset('assets/images/Vector-1.png'),
        ),
        Positioned(
          left: 0,
          top: withBackArrow ? height * 0.3 - 80 : height * 0.3,
          child: Image.asset('assets/images/Vector.png'),
        ),
        Positioned(
          bottom: 0,
          child: Image.asset('assets/images/BG1.png'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: height,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: withBackArrow ? 0 : 80),
              child: const Logo(width: 228, height: 120, color: Colors.black),
            ),
          ],
        )
      ],
    );
  }
}
