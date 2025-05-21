import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:todays_drink/mainscreens/calendar_screen.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:todays_drink/providers/profile_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const _ch = MethodChannel('com.waithealth/drink');

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
  Timer? _periodicTimer; // Timer 객체를 선언합니다.

  int _drinkCount = 0;      // 처음 0으로 시작

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

  final List<FlSpot> _previousBac = [];      // “직전 측정” (원하면 서버에서 받아서 넣어두세요)
  final List<FlSpot> _currentBac = [];       // 이번 측정에서 쌓일 값

  late DateTime _sessionStart;               // x축(경과 시간) 계산용
  double bac = 0.001; // BAC 수치 초기화

  Future<void> _saveDrunkennessData(String title) async {
    final accessToken = Provider.of<ProfileProvider>(context, listen: false).accessToken;
    final now = DateTime.now();
    final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final response = await http.post(
      Uri.parse('http://54.180.90.1:8080/calender/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "date": dateStr,
        "title": title,
        "type": widget.drinkType,   // "soju" or "beer"
        "unit": "잔",
        "count": _drinkCount.toString(),
      }),
    );

    print("📡 보내는 값: ${{
      "date": dateStr,
      "title": title,
      "type": widget.drinkType,
      "unit": "잔",
      "count": _drinkCount.toString(),
    }}");

    if (response.statusCode == 200) {
      print("✅ 저장 성공");
    } else {
      print("❌ 저장 실패: ${response.statusCode} / ${response.body}");
    }
  }

  Future<String?> _showTitleInputDialog(BuildContext context) {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: Container(
            width: 400,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "기록 제목 입력",
                  style: TextStyle(
                    fontFamily: "NotoSansKR",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller,
                    maxLength: 20,
                    decoration: InputDecoration(
                      hintText: "오늘의 기록",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      border: InputBorder.none,
                      counterText: "",
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, controller.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    "저장",
                    style: TextStyle(
                      fontFamily: "NotoSansKR",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    
    _sessionStart = DateTime.now();          // ★ 측정 시작 시각 기록

    _ch.setMethodCallHandler((call) async {
          if (call.method == 'drinkCount') {
            setState(() => _drinkCount = call.arguments as int);
          }
           if (call.method == 'bacUpdate') {
      setState(() {
        bac = (call.arguments as num).toDouble();
      });
    }
        });

        // ▼ 5 분마다 한 번씩 ‘pull’ 호출
    _periodicTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      try {
        // 네이티브에서 최신 BAC 한 번 가져오기
        final num latest = await _ch.invokeMethod('getLatestBac');
        _applyNewBac(latest.toDouble());
      } on PlatformException catch (e) {
        debugPrint('getLatestBac 실패: $e');
      }
    });
    _currentBac.add(FlSpot(0, bac));   // ★ 그래프 데이터 쌓기
        
    

    drunkennessLevel = getDrunkennessLevel(bac);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();
  }

// BAC 적용 → 단계-색·메시지 갱신
  void _applyNewBac(double newBac) {
  final minutes =
      DateTime.now().difference(_sessionStart).inMinutes.toDouble();
    setState(() {
      bac = newBac;
      drunkennessLevel = getDrunkennessLevel(bac);

    _currentBac.add(FlSpot(minutes, bac));   // ★ 그래프 데이터 쌓기
    // 200점 정도까지만 유지 (메모리·성능 보호)
    if (_currentBac.length > 200) _currentBac.removeAt(0);
    });
  }
  @override
  void dispose() {
    _periodicTimer?.cancel();   // ⬅️ 타이머 해제
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
                                    onPressed: () async {
                                      final title = await _showTitleInputDialog(context);

                                      if (title != null && title.isNotEmpty) {
                                        await _saveDrunkennessData(title);

                                        if (!mounted) return;

                                        Navigator.pop(context); // 다이얼로그 닫기
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (_) => CalendarScreen()),
                                              (route) => false,
                                        );
                                      }
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
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
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
                  SizedBox(height: 7),
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
                  SizedBox(height: 20),
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
                  SizedBox(height: 25), 
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
                            width: max(MediaQuery.of(context).size.width - 48, 200),  // 좌우 24씩 패딩 빼주기
                            height: 270,
                            child: LineChart(
                              LineChartData(
                                minY: 0.0,
                                maxY: 0.25,
                                minX: 0,
                                maxX: (_currentBac.isNotEmpty 
                                ? _currentBac.last.x : 0) + 1, // x축 범위를 최신 값에 맞춰 늘림
                                backgroundColor: Colors.transparent,
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      getTitlesWidget: (value, _) {
                                        int minutes = value.toInt();
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
                                  // 직전 측정(있을 때만)
                                  if (_previousBac.isNotEmpty)
                                    LineChartBarData(
                                      spots: _previousBac,
                                      isCurved: false,
                                      barWidth: 3,
                                      color: Colors.blue,
                                      dotData: FlDotData(show: false),
                                    ),
                                  // 이번 측정
                                  LineChartBarData(
                                    spots: _currentBac,
                                    isCurved: false,
                                    barWidth: 3,
                                    color: const Color(0xFFFE8989),
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
