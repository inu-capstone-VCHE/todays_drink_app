import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:todays_drink/mainscreens/calendar_screen.dart';
import 'package:flutter/services.dart';

const _ch = MethodChannel('com.waithealth/drink');

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
  int _drinkCount = 0;      // 처음 0으로 시작

  late AnimationController _animationController;
  int drunkennessLevel = 4;

  late DrunkennessStageData stage;

  final Map<int, DrunkennessStageData> stageDataMap = {
    1: DrunkennessStageData(messages: ["1단계 메세지"]),
    2: DrunkennessStageData(messages: ["2단계 메세지"]),
    3: DrunkennessStageData(messages: ["3단계 메세지"]),
    4: DrunkennessStageData(messages: ["4단계 메세지"]),
    5: DrunkennessStageData(messages: ["5단계 메세지"]),
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

  double bac = 0.001; // BAC 수치 초기화

  @override
  void initState() {
    super.initState();

    _ch.setMethodCallHandler((call) async {
          if (call.method == 'drinkCount') {
            setState(() => _drinkCount = call.arguments as int);
          }
           if (call.method == 'bacUpdate') {
      setState(() {
        bac = (call.arguments as num).toDouble();
        drunkennessLevel = getDrunkennessLevel(bac);
        stage = stageDataMap[drunkennessLevel]!;
      });
    }
        });
        

    drunkennessLevel = getDrunkennessLevel(bac);
    stage = stageDataMap[drunkennessLevel]!;

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
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
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
                    stage.messages[0],
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "$_drinkCount 잔 마시는 중 🍸",
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 30),
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
