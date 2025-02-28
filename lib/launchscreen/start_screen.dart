import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // 🔥 전체를 중앙 정렬
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 🔥 세로 중앙 정렬
          crossAxisAlignment: CrossAxisAlignment.center, // 🔥 가로 중앙 정렬
          children: [
            SizedBox(
              width: 321, // 🔥 피그마 width 적용
              height: 44, // 🔥 피그마 height 적용
              child: Text(
                "잔 속 취기, AI로 읽는다!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: "NotoSansKR",
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10), // 🔥 간격 조정
            SizedBox(
              width: 234, // 🔥 피그마 width 적용
              height: 48, // 🔥 피그마 height 적용
              child: Text(
                "오늘의 한 잔",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 38,
                  fontFamily: "BMJUA",
                  fontWeight: FontWeight.normal,
                  color: Colors.teal,
                ),
              ),
            ),
            const SizedBox(height: 60), // 🔥 텍스트와 이미지 사이 간격 조정
            Image.asset(
              'assets/alcohols5.png',
              width: 150, // 🔥 이미지 크기 조정
            ),
          ],
        ),
      ),
    );
  }
}
