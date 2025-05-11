import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:todays_drink/mainscreens/calendar_screen.dart';
import 'package:fl_chart/fl_chart.dart';

// 단계별 데이터 구조
class DrunkennessStageData {
  final List<String> messages;

  DrunkennessStageData({
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

final Map<int, Color> bacColorByLevel = {
  1: Color(0xFFFF9191),
  2: Color(0xFFFF7373),
  3: Color(0xFFFF5555),
  4: Color(0xFFFF3737),
  5: Color(0xFFFF1919),
};

int getDrunkennessLevel(double bac) {
  if (bac <= 0.03) return 1;
  if (bac <= 0.06) return 2;
  if (bac <= 0.10) return 3;
  if (bac <= 0.20) return 4;
  return 5;
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

  double bac = 0.08;

  final List<FlSpot> previousBAC = [
    FlSpot(0, 0.02),
    FlSpot(1, 0.03),
    FlSpot(2, 0.03),
    FlSpot(3, 0.05),
    FlSpot(4, 0.08),
    FlSpot(5, 0.07),
    FlSpot(6, 0.08),
    FlSpot(7, 0.09),
    FlSpot(8, 0.11),
    FlSpot(9, 0.124),
    FlSpot(10, 0.122),
    FlSpot(11, 0.127),
    FlSpot(12, 0.131),
    FlSpot(13, 0.134),
    FlSpot(14, 0.135),
    FlSpot(15, 0.140),
  ];

  final List<FlSpot> currentBAC = [
    FlSpot(0, 0.010),
    FlSpot(1, 0.028),
    FlSpot(2, 0.045),
    FlSpot(3, 0.045),
    FlSpot(4, 0.075),
    FlSpot(5, 0.079),
    FlSpot(6, 0.085),
    FlSpot(7, 0.110),
    FlSpot(8, 0.125),
    FlSpot(9, 0.124),
    FlSpot(10, 0.126),
    FlSpot(11, 0.129),
    FlSpot(12, 0.120),
    FlSpot(13, 0.130),
    FlSpot(14, 0.132),
    FlSpot(15, 0.138),
  ];

  @override
  void initState() {
    super.initState();
    drunkennessLevel = getDrunkennessLevel(bac);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();
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
        leading: Container(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: Colors.white,
                    child: SizedBox(
                      width: 400,
                      height:200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              "측정 종료",
                              style: TextStyle(
                                fontFamily: "NotoSansKR",
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              "측정 결과를 저장하고 나가거나,\n계속 측정할 수 있어요.",
                              style: TextStyle(
                                fontFamily: "NotoSansKR",
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.black),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      minimumSize: const Size(0, 48), // height 고정, width는 Expanded가 조절
                                    ),
                                    child: const Text(
                                      "계속\n측정하기",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "NotoSansKR",
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context); // 다이얼로그 닫기
                                      // _saveDrunkennessData();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (_) => CalendarScreen()),
                                            (route) => false,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[850],
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      minimumSize: const Size(0, 48),
                                    ),
                                    child: const Text(
                                      "저장하고\n나가기",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "NotoSansKR",
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
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
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "현재 예상 BAC 수치: ",
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9191),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 1),
                  Text(
                    "${bac.toStringAsFixed(3)}%",
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: bacColorByLevel[drunkennessLevel],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10),
                  Text(
                   "※ 위 수치는 추정치일 뿐 사람마다 개인차가 있을 수 있음.",
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "8 잔 마시는 중 🍸",
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 70),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 0.0, bottom: 4.0),
                        child: Text(
                          "BAC (%)",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: SizedBox(
                            width: 1000,
                            height: 270,
                            child: LineChart(
                              LineChartData(
                                minY: 0.0,
                                maxY: 0.25,
                                backgroundColor: Colors.transparent,
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      getTitlesWidget: (value, _) {
                                        int minutes = value.toInt() * 5;
                                        int hour = minutes ~/ 60;
                                        int minute = minutes % 60;
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 42,
                                      interval: 0.05,
                                      getTitlesWidget: (value, _) => Padding(
                                        padding: const EdgeInsets.only(right: 4),
                                        child: Text(
                                          value.toStringAsFixed(3),
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: previousBAC,
                                    isCurved: false,
                                    barWidth: 3,
                                    color: Colors.blue, // 직전 측정 그래프 색
                                    dotData: FlDotData(show: false),
                                  ),
                                  LineChartBarData(
                                    spots: currentBAC,
                                    isCurved: false,
                                    barWidth: 3,
                                    color: Color(0xFFFE8989), // 현재 측정 그래프 색
                                    dotData: FlDotData(show: false),
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Center(
                        child: Text(
                          "시간 (hh:mm)",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 현재 측정
                          Container(width: 20, height: 4, color: Color(0xFFFE8989)),
                          SizedBox(width: 6),
                          Text(
                            "현재 BAC 변화량",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),

                          SizedBox(width: 16),

                          // 직전 측정
                          Container(width: 20, height: 4, color: Colors.blue),
                          SizedBox(width: 6),
                          Text(
                            "직전 BAC 변화량",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
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
