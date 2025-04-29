import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';

// 단계별 데이터 구조
class DrunkennessStageData {
  final String title;
  final String subtitle;
  final List<String> messages;

  DrunkennessStageData({
    required this.title,
    required this.subtitle,
    required this.messages,
  });
}

// 물결 애니메이션
class WavePainter extends CustomPainter {
  final double waveSpeed;
  final Color waveColor;
  final double baseYRatio;
  final double timeOffset;

  WavePainter(this.waveSpeed, this.waveColor, this.baseYRatio, {this.timeOffset = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final totalTime = DateTime.now().millisecondsSinceEpoch / 1000 + timeOffset;
    double speed = totalTime * waveSpeed;

    Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          waveColor.withOpacity(0.4),
          waveColor.withOpacity(0.7),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    Path path = Path();
    double waveHeight = 15.0;
    double baseY = size.height * baseYRatio;

    path.moveTo(0, baseY + sin((0 / size.width * 2 * pi) + speed) * waveHeight);

    for (double i = 0; i < size.width; i += 0.5) {
      path.lineTo(i, baseY + sin((i / size.width * 2 * pi) + speed) * waveHeight);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrunkennessScreen extends StatefulWidget {
  final String drinkType;

  const DrunkennessScreen({required this.drinkType, Key? key}) : super(key: key);

  @override
  _DrunkennessScreenState createState() => _DrunkennessScreenState();
}

class _DrunkennessScreenState extends State<DrunkennessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int drunkennessLevel = 4;

  late DrunkennessStageData stage;
  late String _randomMessage;

  final Map<int, DrunkennessStageData> stageDataMap = {
    1: DrunkennessStageData(
      title: "[ 이제 시작이지~ 😁 ]",
      subtitle: "1단계",
      messages: [
        "오늘은 진짜 안 취한다.\n오늘은 진심 간술임.",
        "오늘은 진짜 가볍게 ㄱㄱ",
        "오늘은 취할 생각 없음~ㅎ"
      ],
    ),
    2: DrunkennessStageData(
      title: "[ 텐션 급상승 😜 ]",
      subtitle: "2단계",
      messages: [
        "아 이제 시작 아님??\n한 잔만 더 ㄱㄱ",
        "오늘은 진짜 안 취할 거야 ㅎㅎ\n걱정하지 마~",
        "이제 함 제대로 마셔볼까??"
      ],
    ),
    3: DrunkennessStageData(
      title: "[ 감성 과부하 🥲 ]",
      subtitle: "3단계",
      messages: [
        "야 너 진짜 내가 많이\n좋아하는 거 알지? ㅎㅠㅠ",
        "이거 마시면...\n우리 우정 영원한 거다...",
        "야 걔한테 오랜만에 전화해볼까?"
      ],
    ),
    4: DrunkennessStageData(
      title: "[ 현실 왜곡 🤯 ]",
      subtitle: "4단계",
      messages: [
        "엥 내 에어팟 어디 갔어?..",
        "잠만 핸드폰은 어디감?",
        "간술: 간에다 술붓기 ㅋㅋㅋ"
      ],
    ),
    5: DrunkennessStageData(
      title: "[ 블랙아웃 🫥 ]",
      subtitle: "5단계",
      messages: [
        "숙취와 후회가 내일을 기다려요...",
        "여긴 어디 나는 누구..?\n(집에 가 빨리...)",
        "어제 뭐 했더라...? (기억 삭제)"
      ],
    ),
  };

  double getBaseYRatio(int level) {
    switch (level) {
      case 1:
        return 0.80;
      case 2:
        return 0.70;
      case 3:
        return 0.50;
      case 4:
        return 0.30;
      case 5:
        return 0.10;
      default:
        return 0.90;
    }
  }

  @override
  void initState() {
    super.initState();
    stage = stageDataMap[drunkennessLevel]!;
    _randomMessage = getRandomMessage(stage.messages);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  String getRandomMessage(List<String> messages) {
    final random = Random();
    return messages[random.nextInt(messages.length)];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(
                    1.5,
                    Color(0xFFB2E4FA),
                    getBaseYRatio(drunkennessLevel),
                    timeOffset: 0,
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(
                    1.2,
                    Color(0xFFA3D5F1).withOpacity(0.6),
                    getBaseYRatio(drunkennessLevel) + 0.05,
                    timeOffset: 0.5,
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    stage.title,
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10),
                  Text(
                    stage.subtitle,
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "_ 잔 마시는 중 🍸",
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "\"$_randomMessage\"",
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          // 오른쪽 아래 상태 표시
          Positioned(
            right: 16,
            bottom: 24,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    widget.drinkType == "soju" ? 'assets/soju.png' : 'assets/beer.png',
                    width: 30,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.drinkType == "soju" ? "소주 측정중 ..." : "맥주 측정중 ...",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
