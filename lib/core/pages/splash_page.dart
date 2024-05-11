import 'package:flutter/material.dart';
import 'package:new_challenge/core/widgets/logo.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Logo(
          width: 282,
          height: 149,
          color: Colors.white,
        ),
      ),
    );
  }
}
