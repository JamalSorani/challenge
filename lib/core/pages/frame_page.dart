import 'package:flutter/material.dart';
import 'package:new_challenge/core/routes_names.dart';

class FramePage extends StatefulWidget {
  const FramePage({super.key});

  @override
  State<FramePage> createState() => _FramePageState();
}

class _FramePageState extends State<FramePage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
            height: height * 0.65,
            child: Image.asset(
              'assets/images/fr.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
            Color.fromRGBO(5, 5, 5, 0.55),
            Color.fromRGBO(5, 5, 5, 0),
          ]))),
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0x00050505),
              Color(0xff050505),
            ])),
            margin: EdgeInsets.only(top: height * 0.7),
            height: height * 0.49,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.76,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  '''مرحباً بك في تطبيق تغيير الحياة الخاصة بك
هذا التطبيق سيساعدك على توثيق التحدي الخاص بك
Gamefication Team تم تطوير هذا التطبيق من قبل فريق''',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(RoutesNames.login);
                  },
                  child: const Text(
                    textAlign: TextAlign.center,
                    'ابدأ رحلتك',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
