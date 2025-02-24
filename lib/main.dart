import 'dart:async';
import 'package:flutter/material.dart';
import 'launchscreen/start_screen.dart';
import 'mainscreens/calendar_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '오늘의 한 잔',
      debugShowCheckedModeBanner: false,
      home: StartScreenWithDelay(), // StartScreen 먼저 실행
    );
  }
}

class StartScreenWithDelay extends StatefulWidget {
  @override
  _StartScreenWithDelayState createState() => _StartScreenWithDelayState();
}

class _StartScreenWithDelayState extends State<StartScreenWithDelay> {
  @override
  void initState() {
    super.initState();
    // 3초 후 CalendarScreen으로 이동
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CalendarScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StartScreen(); // StartScreen을 먼저 보여줌
  }
}
