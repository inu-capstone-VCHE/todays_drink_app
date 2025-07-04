import 'package:flutter/material.dart';
import 'package:todays_drink/firstloginscreens/alcoholTolerance_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:todays_drink/providers/profile_provider.dart';

class InputInformationScreen extends StatefulWidget {
  const InputInformationScreen({Key? key}) : super(key: key);

  @override
  @override
  _InputInformationScreenState createState() => _InputInformationScreenState();
}

class _InputInformationScreenState extends State<InputInformationScreen> {
  String? gender;
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  Future<void> saveUserInfo() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final accessToken = profileProvider.accessToken;

    final url = Uri.parse('http://54.180.90.1:8080/user/info');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'gender': gender == '남자', // true or false
          'height': int.tryParse(heightController.text) ?? 0,
          'weight': int.tryParse(weightController.text) ?? 0,
        }),
      );

      if (response.statusCode == 200) {
        // 다음 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AlcoholAmountScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('에러 발생: $e')),
      );
    }
  }

  bool showHeight = false;
  bool showWeight = false;

  bool get isHeightEntered => heightController.text.isNotEmpty;
  bool get isWeightEntered => weightController.text.isNotEmpty;

  bool get isAllInfoEntered => gender != null && isHeightEntered && isWeightEntered;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ✅ 스크롤 가능한 본문
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('당신의 성별은?',
                style: TextStyle(
                    fontFamily: 'NotoSansKR',
                    fontSize: 20,
                    fontWeight: FontWeight.w800
                )
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = '남자';
                        showHeight = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: gender == '남자' ? const Color(0xFFF2D027) : Colors.grey,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '남자',
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = '여자';
                        showHeight = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: gender == '여자' ? const Color(0xFFF2D027) : Colors.grey,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '여자',
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AnimatedOpacity(
              opacity: showHeight ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('당신의 키는?',
                      style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: heightController,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isHeightEntered ? const Color(0xFFF2D027) : Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFF2D027)),
                      ),
                      suffixText: 'cm',
                    ),
                    onChanged: (value) {
                      setState(() {
                        showWeight = value.isNotEmpty;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AnimatedOpacity(
              opacity: showWeight ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('당신의 몸무게는?',
                      style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          fontSize: 20,
                          fontWeight: FontWeight.w800
                      )
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: weightController,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isWeightEntered ? const Color(0xFFF2D027) : Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFF2D027)),
                      ),
                      suffixText: 'kg',
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100), // 여유 공간
          ],
        ),
      ),

      // ✅ 하단 고정 버튼
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: (gender != null && isHeightEntered && isWeightEntered)
                  ? const Color(0xFF2E7B8C)
                  : Colors.grey[300],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: isAllInfoEntered
                ? () async {
              await saveUserInfo(); // 서버에 정보 저장
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AlcoholAmountScreen(),
                ),
              );
            }
                : null,
            child: const Text(
              '계속하기',
              style: TextStyle(
                fontSize: 16,
                fontFamily: "NotoSansKR",
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
