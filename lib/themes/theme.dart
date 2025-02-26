import 'package:flutter/material.dart';

class AppTheme {
  // ✅ 색상 설정 (네가 선택한 색상)
  static const Color primaryColor = Color(0xFFF2D027); // 노란색
  static const Color secondaryColor = Color(0xF2C12E); // 짙은 노란색
  static const Color accentColor = Color(0xFF2E7B8C); // 청록색
  static const Color darkColor = Color(0xFF593B03); // 갈색
  static const Color backgroundColor = Color(0xFFF2ECE4); // 연한 베이지

  // ✅ 텍스트 스타일 설정
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: darkColor,
    fontFamily: 'NotoSansKR',
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: accentColor,
    fontFamily: 'NotoSansKR',
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
    fontFamily: 'NotoSansKR',
  );

  static const TextStyle lightTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: Colors.grey,
    fontFamily: 'NotoSansKR',
  );

  // ✅ 버튼 스타일
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: 'NotoSansKR',
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );
}
