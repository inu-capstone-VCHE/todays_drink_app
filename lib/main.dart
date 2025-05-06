import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:todays_drink/providers/profile_provider.dart';
import 'package:todays_drink/launchscreen/start_screen.dart'; // ✅ StartScreen 임포트

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 필수 초기화
  await initializeDateFormatting('ko_KR', null); // 한글 로케일
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()), // ✅ Provider 등록
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '오늘의 한 잔',
      debugShowCheckedModeBanner: false,
      home: StartScreen(), // ✅ 첫 화면: 외부 파일의 StartScreen
    );
  }
}
