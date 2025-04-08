import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:todays_drink/firstloginscreens/inputinformation_screen.dart';
import 'package:todays_drink/mainscreens/calendar_screen.dart';
import 'package:todays_drink/providers/profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 비동기 초기화
  await initializeDateFormatting('ko_KR', null); // 한글 로케일 설정
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()), // ✅ Provider 등록
      ],
      child: const MyApp(),
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
      home: InputInformationScreen(), // ✅ 캘린더 스크린으로 시작
    );
  }
}
