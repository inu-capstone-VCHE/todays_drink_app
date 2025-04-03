import 'package:flutter/material.dart';

class InputInformationScreen extends StatefulWidget {
  const InputInformationScreen({super.key});

  @override
  _InputInformationScreenState createState() => _InputInformationScreenState();
}

class _InputInformationScreenState extends State<InputInformationScreen> {
  String? gender;
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  bool showHeight = false;
  bool showWeight = false;

  bool get isHeightEntered => heightController.text.isNotEmpty;
  bool get isWeightEntered => weightController.text.isNotEmpty;

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Text('당신의 성별은?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: ['남자', '여자'].map((String value) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = value;
                        showHeight = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      margin: const EdgeInsets.symmetric(horizontal: 2), // ⚠️ 여기를 수정하면 성별 버튼 크기와 간격 조정 가능
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: gender == value ? const Color(0xFFF2D027) : Colors.grey,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          value,
                          style: TextStyle(
                            color: gender == value ? const Color(0xFFF2D027) : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            AnimatedOpacity(
              opacity: showHeight ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('당신의 키는?',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: heightController,
                    textAlign: TextAlign.right, // ✅ 입력 텍스트 오른쪽 정렬
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: isHeightEntered ? const Color(0xFFF2D027) : Colors.grey),
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
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: weightController,
                    textAlign: TextAlign.right, // ✅ 입력 텍스트 오른쪽 정렬
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: isWeightEntered ? const Color(0xFFF2D027) : Colors.grey),
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
            const Spacer(),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E7B8C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('계속하기', style: TextStyle(fontSize: 16)),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}