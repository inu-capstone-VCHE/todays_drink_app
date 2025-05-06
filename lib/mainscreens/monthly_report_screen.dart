import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:todays_drink/providers/profile_provider.dart';

class MonthlyReportScreen extends StatefulWidget {
  @override
  _MonthlyReportScreenState createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  DateTime _selectedMonth = DateTime.now();
  bool _isDropdownOpen = false;
  late FixedExtentScrollController _scrollController;

  final GlobalKey _titleKey = GlobalKey();
  double? _dropdownTop;
  bool _calculatedTop = false;
  double _highlightWidth = 0;

  double _monthDrink = 0;
  double _monthJoin = 0;
  double _compareDrink = 0;
  double _compareJoin = 0;
  int _money = 0;
  double _gookbob = 0;
  int _calories = 0;
  double _runningTime = 0;
  int _abstainDays = 0;


  List<DateTime> get _availableMonths {
    final now = DateTime.now();
    return List.generate(24, (i) => DateTime(now.year, now.month - i));
  }

  Future<void> fetchMonthlyReport() async {
    final formattedDate = DateFormat('yyyy-MM').format(_selectedMonth);
    final url = Uri.parse('http://54.180.90.1:8080/report/');

    final accessToken = Provider.of<ProfileProvider>(context, listen: false).accessToken;

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({"date": formattedDate}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final report = data[0];
          setState(() {
            _monthDrink = double.parse(report['monthDrink']);
            _monthJoin = double.parse(report['monthJoin']);
            _compareDrink = double.parse(report['compareDrink']);
            _compareJoin = double.parse(report['compareJoin']);
            _money = int.parse(report['money']);
            _gookbob = double.parse(report['gookbob']);
            _calories = int.parse(report['calories']);
            _runningTime = double.parse(report['runningTime']);
            _abstainDays = int.parse(report['abstainDays']);
            _calculateTextWidth();
          });
        }
      } else {
        print("서버 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("연결 실패: $e");
    }
  }

  Widget _buildAbstainText() {
    String text;

    if (_abstainDays == -1) {
      text = "현재 금주 생활 중";
    } else {
      text = "현재 금주 $_abstainDays일째";
    }

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        if (_abstainDays != -1)
          Container(
            width: _highlightWidth,
            height: 11,
            color: const Color(0xFFF2D027),
          ),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'NotoSansKR',
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    final initialIndex = _availableMonths.indexWhere((date) =>
    date.year == _selectedMonth.year && date.month == _selectedMonth.month);
    _scrollController = FixedExtentScrollController(initialItem: initialIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTextWidth();
      final renderBox =
      _titleKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final offset = renderBox.localToGlobal(Offset.zero);
        setState(() {
          _dropdownTop = offset.dy + renderBox.size.height;
          _calculatedTop = true;
        });
      }
      fetchMonthlyReport();
    });
  }

  Map<String, dynamic> getDrinkDiffInfo() {
    final diff = _compareDrink;

    if (diff > 0) {
      return {
        "text": "+${diff.toStringAsFixed(1)}병",
        "color": const Color(0xFFFE8989), // 빨강
      };
    } else if (diff < 0) {
      return {
        "text": "${diff.toStringAsFixed(1)}병",
        "color": const Color(0xFF91B6FD), // 파랑
      };
    } else {
      return {
        "text": "변동없음",
        "color": Colors.grey,
      };
    }
  }

  Map<String, dynamic> getJoinDiffInfo() {
    final diff = _compareJoin;

    if (diff > 0) {
      return {
        "text": "+${diff.toStringAsFixed(0)}일",
        "color": const Color(0xFFFE8989),
      };
    } else if (diff < 0) {
      return {
        "text": "${diff.toStringAsFixed(0)}일",
        "color": const Color(0xFF91B6FD),
      };
    } else {
      return {
        "text": "변동없음",
        "color": Colors.grey,
      };
    }
  }

  void _calculateTextWidth() {
    final text = TextSpan(
      text: _abstainDays == -1
          ? "현재 금주 생활 중"
          : "현재 금주 $_abstainDays일째",
      style: const TextStyle(
        fontFamily: 'NotoSansKR',
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
    final tp = TextPainter(
      text: text,
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    )..layout();

    setState(() {
      _highlightWidth = tp.size.width;
    });
  }

  void _toggleDropdown() {
    setState(() => _isDropdownOpen = !_isDropdownOpen);
  }

  void _selectMonthFromScroll(int index) {
    setState(() => _selectedMonth = _availableMonths[index]);
  }

  void _confirmSelectedMonth() {
    setState(() => _isDropdownOpen = false);
    fetchMonthlyReport();
  }

  @override
  Widget build(BuildContext context) {
    final drinkDiff = getDrinkDiffInfo();
    final joinDiff = getJoinDiffInfo();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 56,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: 0,
                            child: Icon(Icons.close),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat('yyyy년 M월 리포트')
                                    .format(_selectedMonth),
                                key: _titleKey,
                                style: const TextStyle(
                                  fontFamily: 'NotoSansKR',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: _toggleDropdown,
                                child: Icon(
                                  _isDropdownOpen
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!_isDropdownOpen)
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.black),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "당신은",
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Container(
                              width: _highlightWidth,
                              height: 11,
                              color: const Color(0xFFF2D027),
                              margin: const EdgeInsets.only(bottom: 0),
                            ),
                            Text(
                              _abstainDays == -1
                                  ? "현재 금주 생활 중"
                                  : "현재 금주 $_abstainDays일째",
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            // 왼쪽
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '  한 달 동안 마신 술의 양',
                                    style: TextStyle(
                                      fontFamily: 'NotoSansKR',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF7F7F7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '$_monthDrink',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontFamily: 'NotoSansKR',
                                                fontWeight: FontWeight.w900,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Text(' 병', style: TextStyle(fontSize: 16, fontFamily: 'NotoSansKR')),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const Text('저번달 대비', style: TextStyle(fontFamily: 'NotoSansKR', color: Colors.grey)),
                                        const SizedBox(height: 8),

                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: drinkDiff["color"],
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            drinkDiff["text"],
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'NotoSansKR',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // 오른쪽
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '  이번 달 마신 횟수',
                                    style: TextStyle(
                                      fontFamily: 'NotoSansKR',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF7F7F7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${_monthJoin.toInt()}',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontFamily: 'NotoSansKR',
                                                fontWeight: FontWeight.w900,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Text(' 일', style: TextStyle(fontSize: 16, fontFamily: 'NotoSansKR')),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const Text('저번달 대비', style: TextStyle(fontFamily: 'NotoSansKR', color: Colors.grey)),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: joinDiff["color"],
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            joinDiff["text"],
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'NotoSansKR',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '알려드려요  ',
                                  style: TextStyle(
                                    fontFamily: 'NotoSansKR',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: '음주 TMI',
                                  style: TextStyle(
                                    fontFamily: 'NotoSansKR',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        //  술로 낭비한 돈 + 국밥
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  '술로 날린 돈',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'NotoSansKR',
                                      color: Colors.black87
                                  ),
                                ),
                                const SizedBox(height: 8),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '$_money',  // 숫자 0 스타일
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.w900,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  원',  // '원' 글자 스타일
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'NotoSansKR',
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Image.asset('assets/soup.png', width: 80),
                                const SizedBox(height: 8),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '국밥이 무려! ',  // 숫자 0 스타일
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'NotoSansKR',
                                          color: Colors.black87,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' $_gookbob그릇',  // '원' 글자 스타일
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 칼로리 + 달리기 시간
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  '술 마시면서 얻은 칼로리',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'NotoSansKR',
                                      color: Colors.black87
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // 기존 Text 위젯 대신 RichText 사용!
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '$_calories',  // 숫자 0 스타일
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.w900,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  kcal',  // '원' 글자 스타일
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'NotoSansKR',
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Image.asset('assets/running.png', width: 80),
                                const SizedBox(height: 8),
                                // 기존 Text 위젯 대신 RichText 사용!
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '$_runningTime시간',  // 숫자 0 스타일
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '의 달리기 필요!',  // '원' 글자 스타일
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'NotoSansKR',
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isDropdownOpen && _dropdownTop != null)
            Positioned(
              top: _dropdownTop!,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _confirmSelectedMonth,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      color: Colors.white,
                      child: ListWheelScrollView.useDelegate(
                        controller: _scrollController,
                        itemExtent: 36,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: _selectMonthFromScroll,
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: _availableMonths.length,
                          builder: (context, index) {
                            final date = _availableMonths[index];
                            final isSelected = date.year == _selectedMonth.year &&
                                date.month == _selectedMonth.month;
                            return Container(
                              width: double.infinity,
                              height: 40,
                              color: isSelected
                                  ? Colors.grey[200]
                                  : Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                DateFormat('yyyy년 M월').format(date),
                                style: TextStyle(
                                  fontFamily: 'NotoSansKR',
                                  fontSize: 16,
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.grey[500],
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}