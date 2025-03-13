import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

class DrunkennessScreen extends StatefulWidget {
  @override
  _DrunkennessScreenState createState() => _DrunkennessScreenState();
}

class _DrunkennessScreenState extends State<DrunkennessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(); // 애니메이션 무한 반복
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("취기 측정 모드"),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "[ 텐션 급상승 😜 ]",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                SizedBox(height: 10),
                Text(
                  "2단계",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                SizedBox(height: 20),
                Text(
                  "_ 잔 마시는 중 🍸",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "\"오늘은 진짜 안 취할거야 ㅎㅎ 걱정하지마~\"",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(_animationController.value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.5) // 물 색깔 (투명도 조절)
      ..style = PaintingStyle.fill;

    Path path = Path();
    double waveHeight = 20.0; // 물결 높이
    double speed = animationValue * 2 * pi; // 물결 움직임 속도

    path.moveTo(0, size.height * 0.8);

    for (double i = 0; i < size.width; i++) {
      path.lineTo(i, size.height * 0.8 + sin((i / size.width * 2 * pi) + speed) * waveHeight);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return true;
  }
}
