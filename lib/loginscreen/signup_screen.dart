import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../launchscreen/start_screen2.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "회원가입",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,

      // ✅ 스크롤 가능한 입력 필드들
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField(hint: "이름", icon: Icons.person, controller: _nameController),
              buildTextField(hint: "생년월일", icon: Icons.calendar_today, controller: _birthController),
              buildTextField(hint: "이메일", icon: Icons.email, controller: _emailController),

              buildPasswordField(
                hint: "비밀번호",
                isVisible: _passwordVisible,
                controller: _passwordController,
                toggle: () {
                  setState(() => _passwordVisible = !_passwordVisible);
                },
              ),
              buildPasswordField(
                hint: "비밀번호 확인",
                isVisible: _confirmPasswordVisible,
                controller: _confirmPasswordController,
                toggle: () {
                  setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
                },
              ),

              buildTextField(hint: "닉네임", icon: Icons.person, controller: _nicknameController),

              const SizedBox(height: 100), // 키보드 겹침 방지용 여유
            ],
          ),
        ),
      ),

      // ✅ 하단 고정 버튼
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: signupUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D6876),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              "회원가입 완료",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({required String hint, required IconData icon, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required String hint,
    required bool isVisible,
    required TextEditingController controller,
    required VoidCallback toggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: toggle,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

  Future<void> signupUser() async {
    final url = Uri.parse('http://54.180.90.1:8080/user/join');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'nickname': _nicknameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'birth': int.tryParse(_birthController.text) ?? 0,
        }),
      );

      if (response.statusCode == 200) {
        _showSignupSuccessDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('에러 발생: $e')),
      );
    }
  }

  void _showSignupSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("회원가입 성공!🎉🎉"),
          content: const Text("회원가입이 완료되었습니다."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen2()),
                );
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }
}
