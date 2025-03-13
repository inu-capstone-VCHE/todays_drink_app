import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _passwordVisible = false; // 비밀번호 보기 여부
  bool _confirmPasswordVisible = false; // 비밀번호 확인 보기 여부

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // 🔙 뒤로 가기 기능
        ),
        elevation: 0, // 그림자 제거
        backgroundColor: Colors.transparent, // ✅ 배경색 투명 (기본 배경 유지)
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // 🔥 상단 여백 추가

            // ✅ 이름 입력 필드
            buildInputField(Icons.person, "이름"),

            // ✅ 생년월일 입력 필드
            buildInputField(Icons.calendar_today, "생년월일"),

            // ✅ 이메일 입력 필드
            buildInputField(Icons.email, "이메일"),

            // ✅ 비밀번호 입력 필드
            buildPasswordField("비밀번호", _passwordVisible, (value) {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            }),

            // ✅ 비밀번호 확인 입력 필드
            buildPasswordField("비밀번호 확인", _confirmPasswordVisible, (value) {
              setState(() {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              });
            }),

            // ✅ 닉네임 입력 필드 + 중복 확인 버튼
            Row(
              children: [
                Expanded(
                  child: buildInputField(Icons.person, "닉네임"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // TODO: 닉네임 중복 확인 기능 추가
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB0C4DE), // 버튼 색상 (연한 청록색)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "중복 확인",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30), // 🔥 버튼 위 여백

            // ✅ 계속하기 버튼
            SizedBox(
              width: screenWidth,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 회원가입 진행
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D6876), // 버튼 색상 (진한 청록색)
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "계속하기",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅ 배경색 원래 기본값 유지
    );
  }

  // 🔥 일반 입력 필드 (아이콘 + 텍스트, 얇은 실선 테두리 추가)
  Widget buildInputField(IconData icon, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.grey),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor, // ✅ 배경색을 화면 배경과 동일하게 설정
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1), // ✅ 얇은 실선 테두리 추가
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1), // ✅ 기본 테두리 스타일
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[500]!, width: 1.5), // ✅ 포커스 시 조금 더 진한 색
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

  // 🔥 비밀번호 입력 필드 (비밀번호 보기 기능 포함, 얇은 실선 테두리 추가)
  Widget buildPasswordField(String hintText, bool isVisible, Function(bool) toggleVisibility) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
            onPressed: () => toggleVisibility(!isVisible),
          ),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor, // ✅ 배경색을 화면 배경과 동일하게 설정
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1), // ✅ 얇은 실선 테두리 추가
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1), // ✅ 기본 테두리 스타일
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[500]!, width: 1.5), // ✅ 포커스 시 조금 더 진한 색
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}
