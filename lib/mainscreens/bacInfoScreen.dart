import 'package:flutter/material.dart';

class BacScreen extends StatelessWidget {
  const BacScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          "BAC (Blood Alcohol Concentration)는 혈액 속 알코올 농도를 의미해.\n\n"
              "- BAC 0.03%: 기분 좋음\n"
              "- BAC 0.06%: 취기 시작\n"
              "- BAC 0.10% 이상: 음주운전 기준 초과\n\n"
              "BAC는 주로 혈액 검사로 측정하지만, 음주 측정기를 통한 BrAC(호흡 알코올 농도)로도 추정할 수 있어.",
          style: TextStyle(
            fontFamily: 'NotoSansKR',
            fontSize: 15,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
