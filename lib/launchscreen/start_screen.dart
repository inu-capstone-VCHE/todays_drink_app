import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar를 빼고, 화면 전체를 사용하도록 설정
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          // 위/아래 공간을 여유 있게 주고 싶으면 vertical 패딩도 추가
          child: Column(
            // 공간을 골고루 분배하여, 텍스트는 중앙쯤, 이미지는 아래쪽에 위치
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 상단에 일부러 공간을 조금 더 두고 싶다면 SizedBox를 추가할 수도 있음
              // SizedBox(height: 50),

              // 가운데 영역(텍스트)
              Column(
                children: [
                  Text(
                    "잔 속 취기, AI로 읽는다!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "오늘의 한 잔",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.teal, // 원하는 색상으로 변경
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // 하단 이미지
              Image.asset(
                'assets/alcohols5.png',
                // 원하는 크기가 있다면 width나 height를 지정
                // 예: width: 200, height: 100
              ),
            ],
          ),
        ),
      ),
    );
  }
}
