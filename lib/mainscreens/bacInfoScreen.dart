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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'BAC 정보',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'NotoSansKR',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea( // ← 스크롤 막힘 방지 핵심 포인트
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "🍺 BAC란 무엇인가요?",
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "BAC (Blood Alcohol Concentration)는 혈액 속 알코올 농도를 의미합니다. "
                    "즉, 혈액 100mL에 포함된 알코올의 비율을 %로 나타낸 것 입니다. "
                    "BAC는 마신 술의 양, 시간, 성별, 체중, 식사 여부에 따라 달라집니다.",
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "🍷 BAC 단계별 취기 상태",
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ..._buildBacStageList(),
              const SizedBox(height: 24),

              const Text(
                "🚗 나라별 음주운전 기준 (면허 정지/취소)",
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ..._buildCountryBacList(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBacStageList() {
    final List<Map<String, String>> stages = [
      {'level': '0.01% ~ 0.03%', 'desc': '기분 상승, 긴장 완화'},
      {'level': '0.04% ~ 0.06%', 'desc': '억제력 감소, 반응속도 저하'},
      {'level': '0.07% ~ 0.09%', 'desc': '판단력 저하, 운전 위험'},
      {'level': '0.10% ~ 0.12%', 'desc': '말이 어눌해짐, 감정 증폭'},
      {'level': '0.13% ~ 0.15%', 'desc': '현기증, 구토, 판단력 상실'},
      {'level': '0.16% ~ 0.30%', 'desc': '기억력 저하, 정신 혼미'},
      {'level': '0.31% 이상', 'desc': '의식 저하 또는 사망 위험'},
    ];

    return stages.map((stage) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Text(
                stage['level']!,
                style: const TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                stage['desc']!,
                style: const TextStyle(fontFamily: 'NotoSansKR'),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildCountryBacList() {
    final List<Map<String, String>> countries = [
      {'country': '🇰🇷 대한민국', 'info': '정지: 0.03% / 취소: 0.08%'},
      {'country': '🇺🇸 미국', 'info': '주마다 다름 (대부분 0.08% 이상)'},
      {'country': '🇯🇵 일본', 'info': '정지: 0.03% / 취소: 0.05%'},
      {'country': '🇩🇪 독일', 'info': '정지: 0.05% / 취소: 0.11%'},
      {'country': '🇨🇳 중국', 'info': '경범죄: 0.02% / 형사처벌: 0.08%'},
    ];

    return countries.map((row) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                row['country']!,
                style: const TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                row['info']!,
                style: const TextStyle(fontFamily: 'NotoSansKR'),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
