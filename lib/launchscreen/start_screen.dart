import 'dart:async';
import 'package:flutter/material.dart';
import 'start_screen2.dart'; // ✅ StartScreen2 import

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();

    // ⏳ 5초 뒤에 StartScreen2로 이동
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StartScreen2()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 5), // 텍스트를 위로 올리기 위한 Spacer

            Column(
              children: const [
                Text(
                  "잔 속 취기, AI로 읽는다!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "NotoSansKR",
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "오늘의 한 잔",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 38,
                    fontFamily: "BMJUA",
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF2D6876),
                  ),
                ),
              ],
            ),

            const Spacer(flex: 4), // 이미지와의 거리 맞추기

            Image.asset(
              'assets/drinks.png',
              width: screenWidth * 0.8,
              height: screenHeight * 0.2,
              fit: BoxFit.contain,
            ),

            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
