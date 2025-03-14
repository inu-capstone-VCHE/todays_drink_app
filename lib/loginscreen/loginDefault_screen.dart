import 'package:flutter/material.dart';
import 'signup_screen.dart'; // ✅ 회원가입 화면 import

class LoginDefaultScreen extends StatefulWidget {
  const LoginDefaultScreen({Key? key}) : super(key: key);

  @override
  _LoginDefaultScreenState createState() => _LoginDefaultScreenState();
}

class _LoginDefaultScreenState extends State<LoginDefaultScreen> {
  bool _passwordVisible = false; // 비밀번호 보이기 여부

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // 🔙 뒤로 가기 기능
        ),
        elevation: 0, // 그림자 제거
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ 로그인 타이틀
            const Center(
              child: Text(
                "로그인",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // ✅ 이메일 입력 필드
            const Text("이메일", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "이메일을 입력해주세요.",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ 비밀번호 입력 필드
            const Text("비밀번호", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              obscureText: !_passwordVisible, // 비밀번호 가리기
              decoration: InputDecoration(
                hintText: "비밀번호를 입력해주세요.",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ✅ 로그인 버튼
            SizedBox(
              width: screenWidth,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 로그인 기능 추가
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D6876), // 버튼 색상
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "로그인",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ 회원가입 버튼 (제대로 작동하도록 수정)
            Center(
              child: GestureDetector(
                onTap: () {
                  print("회원가입 버튼 클릭됨! 🚀"); // ✅ 디버깅용 출력 (필요하면 확인)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()), // ✅ 회원가입 화면 이동
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: "아직 회원이 아니신가요? ",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "회원가입",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D6876),
                          decoration: TextDecoration.underline, // ✅ 밑줄 추가
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
