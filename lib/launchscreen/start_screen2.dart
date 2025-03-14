import 'package:flutter/material.dart';
import '../loginscreen/loginDefault_screen.dart'; // ✅ 로그인 화면 import
import '../loginscreen/signup_screen.dart';     // ✅ 회원가입 화면 import

class StartScreen2 extends StatelessWidget {
  const StartScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height; // 📌 화면 높이 가져오기
    double screenWidth = MediaQuery.of(context).size.width; // 📌 화면 너비 가져오기

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center( // 📌 전체를 중앙 정렬
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 📌 위에서부터 정렬
          crossAxisAlignment: CrossAxisAlignment.center, // 📌 가로 중앙 정렬
          children: [
            const Spacer(flex: 5), // 📌 위쪽 여백 (텍스트 위치 조정)
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
                    color: Color(0xFF2D6876), // 📌 진한 청록색
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2), // 📌 텍스트 아래 간격 조정

            // ✅ 로그인 버튼
            SizedBox(
              width: screenWidth * 0.7, // 📌 화면 너비의 70%
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // ✅ 로그인 버튼 클릭 시 LoginDefaultScreen으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginDefaultScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D6876), // 📌 버튼 색상 (진한 청록색)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 📌 모서리 둥글게
                  ),
                ),
                child: const Text(
                  "로그인",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white, // 📌 글자색 흰색
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10), // 🔥 버튼 간격 조정

            // ✅ 회원가입 버튼
            SizedBox(
              width: screenWidth * 0.7, // 📌 화면 너비의 70%
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  // ✅ 회원가입 버튼 클릭 시 SignupScreen으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2D6876), width: 2), // 📌 테두리 추가
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 📌 모서리 둥글게
                  ),
                ),
                child: const Text(
                  "회원가입",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D6876), // 📌 글자색 (진한 청록색)
                  ),
                ),
              ),
            ),

            const Spacer(flex: 2), // 📌 버튼 아래 간격 추가

            // ✅ 이미지 (술 병 5개)
            Image.asset(
              'assets/drinks.png',
              width: screenWidth * 0.8, // 📌 화면 너비의 80% 크기로 설정
              height: screenHeight * 0.2, // 📌 화면 높이의 20% 크기로 설정
              fit: BoxFit.contain,
            ),

            const Spacer(flex: 1), // 📌 아래 여백 추가
          ],
        ),
      ),
    );
  }
}
