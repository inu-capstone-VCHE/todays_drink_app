import 'package:flutter/material.dart';
import 'settingscreen/setting_screen.dart';
import 'firstloginscreens//inputinformation_screen.dart';
import 'firstloginscreens/alcoholTolerance_screen.dart';
import 'firstloginscreens/pledge_screen.dart';

/*
import 'dart:async';
import 'package:intl/date_symbol_data_local.dart'; // ✅ 한글 날짜 포맷 초기화용 패키지 추가
import 'launchscreen/start_screen.dart';
import 'launchscreen/start_screen2.dart';
import 'mainscreens/calendar_screen.dart';
import 'loginscreen/loginDefault_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ 비동기 초기화 보장
  await initializeDateFormatting('ko_KR', null); // ✅ 한글 로케일 데이터 초기화
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '오늘의 한 잔',
      debugShowCheckedModeBanner: false,
      home: StartScreenWithDelay(), // ✅ 시작 화면 유지
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
    // ✅ 3초 후 CalendarScreen으로 이동
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartScreen2()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StartScreen(); // ✅ 시작 화면 먼저 표시
  }
}
*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Setting Screen Test',
      debugShowCheckedModeBanner: false,
      home: PledgeScreen(),
    );
  }
}
