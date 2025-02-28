import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 🔥 전체를 완벽하게 중앙 정렬
        crossAxisAlignment: CrossAxisAlignment.center, // 🔥 가로 정렬도 중앙
        children: [
          Expanded( // 🔥 전체적으로 아래로 배치
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 🔥 내부 정렬도 중앙
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
                const SizedBox(height: 20),
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
          ),
          Expanded( // 🔥 이미지도 중간 정렬
            flex: 3,
            child: Align(
              alignment: Alignment.center, // 🔥 이미지 중앙 배치
              child: Image.asset(
                'assets/alcohols5.png',
                width: 270,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
