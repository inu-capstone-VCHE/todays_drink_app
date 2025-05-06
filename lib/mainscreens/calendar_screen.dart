import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'drinking_record_screen.dart';
import 'DrunknessScreens/drink_type_selection.dart';
import 'monthly_report_screen.dart';
import 'package:todays_drink/drinking_record.dart';
import 'dart:math';
import 'package:todays_drink/settingscreen/setting_screen.dart';
import 'package:provider/provider.dart';
import 'package:todays_drink/providers/profile_provider.dart';
import 'package:todays_drink/mainscreens/bacInfoScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showRecord = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  double _calendarHeight = 600;
  double _recordHeight = 230;
  String _nickname = '';

  Map<String, List<DrinkingRecord>> drinkingRecords = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    fetchUserNickname();
    fetchUserRecords();
  }

  Future<void> fetchUserNickname() async {
    final accessToken = Provider.of<ProfileProvider>(context, listen: false).accessToken;

    try {
      final response = await http.get(
        Uri.parse('http://54.180.90.1:8080/user'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _nickname = data['nickname'] ?? "";
        });
      } else {
        print("닉네임 요청 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("닉네임 요청 예외 발생: $e");
    }
  }

  Future<void> fetchUserRecords() async {
    final accessToken = Provider.of<ProfileProvider>(context, listen: false).accessToken;
    print('✅ 토큰: $accessToken');

    final response = await http.get(
      Uri.parse('http://54.180.90.1:8080/calender/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      Map<String, Map<String, DrinkingRecord>> mergedRecords = {};

      for (var item in data) {
        final records = DrinkingRecord.fromJsonList(item); // ✅ 리스트로 받아옴

        for (final record in records) {
          final dateKey = "${record.date.year}-${record.date.month}-${record.date.day}";
          final titleKey = record.title;

          mergedRecords.putIfAbsent(dateKey, () => {});

          if (mergedRecords[dateKey]!.containsKey(titleKey)) {
            final existing = mergedRecords[dateKey]![titleKey]!;

            mergedRecords[dateKey]![titleKey] = DrinkingRecord(
              date: record.date,
              title: record.title,
              sojuAmount: existing.sojuAmount + record.sojuAmount,
              sojuUnit: record.sojuAmount > 0 ? record.sojuUnit : existing.sojuUnit,
              beerAmount: existing.beerAmount + record.beerAmount,
              beerUnit: record.beerAmount > 0 ? record.beerUnit : existing.beerUnit,
            );
          } else {
            mergedRecords[dateKey]![titleKey] = record;
          }
        }
      }

      // List 형태로 변환
      Map<String, List<DrinkingRecord>> loadedRecords = {};
      mergedRecords.forEach((dateKey, titleMap) {
        loadedRecords[dateKey] = titleMap.values.toList();
      });

      setState(() {
        drinkingRecords = loadedRecords;
      });
    } else {
      print("🔥 실패: ${response.statusCode} / ${response.body}");
    }
  }

  Future<void> deleteDrinkingRecord({
    required String date,
    required String title,
    required String accessToken,
  }) async {
    final url = Uri.parse('http://54.180.90.1:8080/calender/delete');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'date': date,
        'title': title,
      }),
    );

    if (response.statusCode == 200) {
      print("✅ 삭제 성공");
    } else {
      print("❌ 삭제 실패: ${response.statusCode}");
      throw Exception("삭제 실패");
    }
  }

  void _showDeleteDialog(DrinkingRecord record, String dateKey) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: SizedBox(
            width: 400,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "음주 기록 삭제",
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
                    "삭제한 내용은 복구할 수 없어!",
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
                        child: ElevatedButton(
                          onPressed: () async {
                            final accessToken = Provider.of<ProfileProvider>(context, listen: false).accessToken;
                            final dateString = "${record.date.year.toString().padLeft(4, '0')}-${record.date.month.toString().padLeft(2, '0')}-${record.date.day.toString().padLeft(2, '0')}";

                            try {
                              await deleteDrinkingRecord(
                                  date: dateString,
                                  title: record.title,
                                  accessToken: accessToken!,
                              );
                            } catch (e) {
                              print ("🔥 삭제 중 오류 발생: $e");
                            }

                            setState(() {
                              drinkingRecords[dateKey]?.remove(record);
                              if (drinkingRecords[dateKey]?.isEmpty ?? true) {
                                drinkingRecords.remove(dateKey);
                                _showRecord = false;
                              }
                            });
                            Navigator.pop(context); // 다이얼로그 닫기
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(0, 48),
                          ),
                          child: const Text(
                            "삭제하기",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "NotoSansKR",
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context); // 그냥 닫기
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(0, 48),
                          ),
                          child: const Text(
                            "닫기",
                            style: TextStyle(
                              color: Colors.black,
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
  }

  Widget _buildDrawer() {
    final profile = Provider.of<ProfileProvider>(context);

    return Drawer(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingScreen()),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFEFEFEF),
                    backgroundImage: profile.imageFile != null ? FileImage(profile.imageFile!) : null,
                    child: profile.imageFile == null
                        ? const Icon(Icons.pets, size: 30, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _nickname,
                      style: const TextStyle(
                        fontFamily: 'NotoSansKR',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            const SizedBox(height: 40),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DrinkTypeSelectionScreen()),
                );
              },
              child: const Text(
                "BAC 측정 모드",
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BacScreen()),
                );
              },
              child: const Text(
                "BAC란?",
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontSize: 18,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildDrinkItem(String asset, String text) {
    return Row(
      children: [
        Image.asset(asset, width: 36, height: 36,),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'NotoSansKR',
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  double _getTextWidth(BuildContext context, String text, double fontSize, FontWeight fontWeight) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: 'NotoSansKR',
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width;
  }

  void _toggleRecord(bool show) {
    setState(() {
      _showRecord = show;
      _calendarHeight = show ? 450 : 600;
      if (show) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _changeMonth(bool isNext) {
    if (isNext &&
        _focusedDay
            .isAfter(DateTime(DateTime.now().year, DateTime.now().month))) {
      return;
    }
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month + (isNext ? 1 : -1),
        1,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _buildDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () => _changeMonth(false),
            ),
            Text(
              "${_focusedDay.year}. ${_focusedDay.month}",
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right,
                  color: _focusedDay.month == DateTime.now().month
                      ? Colors.grey
                      : Colors.black),
              onPressed: _focusedDay.month == DateTime.now().month
                  ? null
                  : () => _changeMonth(true),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.bar_chart_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MonthlyReportScreen()),
            );
          },
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          )
        ],
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! > 10) {
            _toggleRecord(false);
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: _calendarHeight,
                  child: TableCalendar(
                    locale: 'ko_KR',
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.now(),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: CalendarFormat.month,
                    rowHeight: _showRecord ? 65 : 80,
                    onDaySelected: (selectedDay, focusedDay) {
                      if (selectedDay.isAfter(DateTime.now())) return;
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _toggleRecord(true);
                      });
                    },
                    headerVisible: false,
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(
                        fontFamily: 'NotoSansKR',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      weekendTextStyle: TextStyle(
                        fontFamily: 'NotoSansKR',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      outsideTextStyle: TextStyle(
                        fontFamily: 'NotoSansKR',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      todayDecoration: BoxDecoration(
                        color: (_selectedDay == null ||
                            isSameDay(_selectedDay, DateTime.now()))
                            ? Color(0xFFF2D027)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Color(0xFFF2D027),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(
                        fontFamily: 'NotoSansKR',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      selectedTextStyle: TextStyle(
                        fontFamily: 'NotoSansKR',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontFamily: 'NotoSansKR',
                        color: Colors.black,
                      ),
                      weekendStyle: TextStyle(
                        fontFamily: 'NotoSansKR',
                        color: Colors.black,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      dowBuilder: (context, day) {
                        if (day.weekday == DateTime.sunday) {
                          return Center(
                            child: Text(
                              '일',
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else if (day.weekday == DateTime.saturday) {
                          return Center(
                              child: Text(
                                  '토',
                                  style: TextStyle(
                                    fontFamily: 'NotoSansKR',
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  )
                              )
                          );
                        }
                        return null;
                      },
                      defaultBuilder: (context, day, focusedDay) {
                        final isFuture = day.isAfter(DateTime.now()); // 미래 날짜 확인
                        final isSunday = day.weekday == DateTime.sunday;
                        final isSaturday = day.weekday == DateTime.saturday;
                        final dateKey = "${day.year}-${day.month}-${day.day}";
                        final hasRecord = drinkingRecords.containsKey(dateKey);

                        return Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontFamily: 'NotoSansKR',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: hasRecord
                                  ? Colors.transparent
                                  : isFuture
                                  ? Colors.grey
                                  : isSunday
                                  ? Colors.red
                                  : isSaturday
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                          ),
                        );
                      },

                      outsideBuilder: (context, day, focusedDay) {
                        final dateKey = "${day.year}-${day.month}-${day.day}";
                        final hasRecord = drinkingRecords.containsKey(dateKey);

                        return Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontFamily: 'NotoSansKR',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: hasRecord ? Colors.transparent : Colors.grey,
                            ),
                          ),
                        );
                      },

                      markerBuilder: (context, day, events) {
                        String dateKey = "${day.year}-${day.month}-${day.day}";

                        if (drinkingRecords.containsKey(dateKey)) {
                          final record = drinkingRecords[dateKey]!;

                          for (var r in record) {
                            print("✅ $dateKey / title: ${r.title}, soju: ${r.sojuAmount}, beer: ${r.beerAmount}");
                          }

                          String assetPath;

                          final drankSoju = record.any((r) => r.sojuAmount > 0);
                          final drankBeer = record.any((r) => r.beerAmount > 0);


                          if (drankSoju && drankBeer) {
                            final seed = day.year * 10000 + day.month * 100 + day.day;
                            final isSoju = Random(seed).nextBool();
                            assetPath = isSoju ? "assets/soju.png" : "assets/beer.png";
                          } else if (drankSoju) {
                            assetPath = "assets/soju.png";
                          } else if (drankBeer) {
                            assetPath = "assets/beer.png";
                          } else {
                            return null; // 둘 다 안 마셨으면 표시 안 함
                          }

                          return Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                ),
                                Image.asset(
                                  assetPath,
                                  width: 40,
                                  height: 40,
                                ),
                              ],
                            ),
                          );
                        }
                        return null;
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        final dateKey = "${day.year}-${day.month}-${day.day}";
                        final hasRecord = drinkingRecords.containsKey(dateKey);

                        return Center(
                          child: Container(
                            width: 44, // ✅ 기본 선택 원 크기 맞춤
                            height: 44,
                            decoration: BoxDecoration(
                              color: Color(0xFFF2D027),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: hasRecord ? Colors.transparent : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (_showRecord)
              AnimatedBuilder(
                animation: _slideAnimation,
                  builder: (context, child) {
                    final dateKey = "${_selectedDay!.year}-${_selectedDay!.month}-${_selectedDay!.day}";
                    final recordList = drinkingRecords[dateKey];

                    return Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: _recordHeight,
                      child: Transform.translate(
                        offset: Offset(0, _recordHeight * (1 - _slideAnimation.value)),
                        child: Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 60,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                "${_selectedDay!.year}.${_selectedDay!.month}.${_selectedDay!.day}",
                                style: TextStyle(
                                  fontFamily: 'NotoSansKR',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),

                              Expanded(
                                child: recordList != null && recordList.isNotEmpty
                                    ? ListView.builder(
                                  itemCount: recordList.length,
                                  padding: EdgeInsets.only(bottom: 16),
                                  itemBuilder: (context, index) {
                                    final record = recordList[index];

                                    return GestureDetector(
                                      onTap: () => _showDeleteDialog(record, dateKey),
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomLeft,
                                              children: [
                                                Container(
                                                  height: 8,
                                                  width: _getTextWidth(context, record.title, 16, FontWeight.w700),
                                                  color: Color(0xFFF2D027),
                                                  margin: EdgeInsets.only(bottom: 0),
                                                ),
                                                Text(
                                                  record.title,
                                                  style: TextStyle(
                                                    fontFamily: 'NotoSansKR',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            Row(
                                              children: [
                                                if (record.sojuUnit != null)
                                                  _buildDrinkItem("assets/soju.png", "${record.sojuAmount}${record.sojuUnit}"),
                                                if (record.sojuUnit != null && record.beerUnit != null)
                                                  SizedBox(width: 20),
                                                if (record.beerUnit != null)
                                                  _buildDrinkItem(
                                                    "assets/beer.png",
                                                    record.beerUnit == "500ml"
                                                        ? "${(record.beerAmount * 500).toInt()}ml"
                                                        : "${record.beerAmount}${record.beerUnit}",
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                                    : Center(
                                  child: Text(
                                    "작성한 기록이 아직 없어!\n음주 기록을 작성해볼까?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'NotoSansKR',
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DrinkingRecordScreen(
              selectedDate: _selectedDay ?? DateTime.now(),
            )),
          );

          if (result != null && result is DrinkingRecord) {
            String dateKey = "${result.date.year}-${result.date.month}-${result.date.day}";
            setState(() {
              if (!drinkingRecords.containsKey(dateKey)) {
                drinkingRecords[dateKey] = [];
              }
              drinkingRecords[dateKey]!.add(result);
            });
          }
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
        shape: CircleBorder(),
      ),
    );
  }
}