import 'package:flutter/material.dart';
import 'package:todays_drink/mainscreens/calendar_screen.dart';
import 'package:provider/provider.dart';
import 'package:todays_drink/providers/profile_provider.dart';

class PledgeScreen extends StatefulWidget {
  const PledgeScreen({super.key});

  @override
  State<PledgeScreen> createState() => _PledgeScreenState();
}

class _PledgeScreenState extends State<PledgeScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isFilled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        isFilled = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '이번 달 나와의 약속!',
              style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontSize: 20,
                  fontWeight: FontWeight.w800
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '스스로 정한 목표를 통해 건강한 음주 습관을 만들어보세요.',
              style: TextStyle(
                  fontFamily: "NotoSansKR",
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey
              ),
            ),
            const SizedBox(height: 40),
            const Text('선서.', style: TextStyle(
                fontSize: 20,
                fontFamily: "NotoSansKR",
                fontWeight: FontWeight.w500
              )
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                text: '나 ',
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "NotoSansKR",
                    fontWeight: FontWeight.w500
                ),
                children: [
                  const TextSpan(
                    text: '(닉네임)',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "NotoSansKR",
                        fontWeight: FontWeight.w900
                    ),
                  ),
                  const TextSpan(
                      text: ' 은(는)',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "NotoSansKR",
                          fontWeight: FontWeight.w500
                      ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text('한 달 동안', style: TextStyle(
                fontSize: 20,
                fontFamily: "NotoSansKR",
                fontWeight: FontWeight.w500
            )
            ),
            Row(
              children: [
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF2D027), width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF2D027), width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF2D027), width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Text('병 이상',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "NotoSansKR",
                        fontWeight: FontWeight.w500
                    )
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '마시지 않겠습니다.',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: "NotoSansKR",
                      fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/seal.png',
                  height: 45,
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFilled ? const Color(0xFF2E7B8C) : Colors.grey[300],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isFilled
                    ? () {
                  final amount = int.tryParse(_controller.text.trim()) ?? 0;
                  Provider.of<ProfileProvider>(context, listen: false)
                      .updatePledgeLimit(int.parse(_controller.text));
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => CalendarScreen()),
                        (route) => false,
                  );
                }
                    : null,
                child: const Text(
                  '완료',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "NotoSansKR",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
