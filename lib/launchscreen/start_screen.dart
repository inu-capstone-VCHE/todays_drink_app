import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height; // 📌 화면 높이 가져오기

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center( // 📌 전체를 중앙 정렬
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 📌 위에서부터 정렬
          crossAxisAlignment: CrossAxisAlignment.center, // 📌 가로 중앙 정렬
          children: [
            const Spacer(flex: 5), // 📌 위쪽 여백
            Column(
              children: [
                Text(
                  "잔 속 취기, AI로 읽는다!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "NotoSansKR",
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4), // 🔥 텍스트 간격 유지
                Text(
                  "오늘의 한 잔",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 38,
                    fontFamily: "BMJUA",
                    fontWeight: FontWeight.normal,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 1), // 📌 텍스트 아래 간격 조정
            Image.asset(
              'assets/drinks.png',
              width: screenHeight * 0.40, // 📌 화면 높이의 25% 크기로 설정
              height: screenHeight * 0.40, // 📌 화면 높이의 25% 크기로 설정
              fit: BoxFit.contain,
            ),
            const Spacer(flex: 1), // 📌 아래 여백 추가
          ],
        ),
      ),
    );
  }
}
