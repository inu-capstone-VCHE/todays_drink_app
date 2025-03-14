import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'drinking_record_screen.dart';
import 'drunkenness_screen.dart';

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
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "닉네임",
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DrunkennessScreen()),
                );
              },
              child: Text(
                "취기 측정 모드",
                style: TextStyle(
                    fontFamily: 'NotoSansKR',
                    fontSize: 18
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // TODO: 설정 기능 추가
              },
              child: Text(
                "설정",
                style: TextStyle(
                    fontFamily: 'NotoSansKR',
                    fontSize: 18
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                fontFamily: 'NotoSansKR', // 🔥 폰트 적용
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
          onPressed: () {},
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
                        fontFamily: 'NotoSansKR', // 🔥 기본 날짜 폰트 적용
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
                        fontFamily: 'NotoSansKR', // 🔥 오늘 날짜 폰트 적용
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      selectedTextStyle: TextStyle(
                        fontFamily: 'NotoSansKR', // 🔥 선택된 날짜 폰트 적용
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontFamily: 'NotoSansKR', // 🔥 요일 폰트 적용
                        color: Colors.black,
                      ),
                      weekendStyle: TextStyle(
                        fontFamily: 'NotoSansKR', // 🔥 주말 폰트 적용
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

                        return Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: isFuture
                                    ? Colors.grey // 미래 날짜 회색
                                    : isSunday
                                      ? Colors.red // 일요일 날짜 빨강
                                      : isSaturday
                                        ? Colors.blue
                                        : Colors.black,

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
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: _recordHeight,
                    child: Transform.translate(
                      offset: Offset(
                          0, _recordHeight * (1 - _slideAnimation.value)),
                      child: Container(
                        width: double.infinity,
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        color: Colors.grey[200],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 5),
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
                            SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${_selectedDay!.year}.${_selectedDay!.month}.${_selectedDay!.day}",
                                style: TextStyle(
                                  fontFamily: 'NotoSansKR', // 🔥 음주 기록 날짜 폰트 적용
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "작성한 기록이 아직 없어!\n음주 기록을 작성해볼까?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'NotoSansKR', // 🔥 메시지 폰트 적용
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DrinkingRecordScreen()),
          );
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
        shape: CircleBorder(),
      ),
    );
  }
}
