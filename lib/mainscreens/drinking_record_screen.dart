import 'package:flutter/material.dart';

class DrinkingRecordScreen extends StatefulWidget {
  @override
  _DrinkingRecordScreenState createState() => _DrinkingRecordScreenState();
}

class _DrinkingRecordScreenState extends State<DrinkingRecordScreen> {
  TextEditingController _textController = TextEditingController();
  int _charCount = 0;

  String? _selectedSojuUnit;
  double _sojuAmount = 1.0;
  bool _isSojuSelected = false; // 소주 관련 변수

  String? _selectedBeerUnit;
  double _beerAmount = 1.0;
  bool _isBeerSelected = false; // 맥주 관련 변수

  // 버튼 활성화 여부 확인 함수
  bool _isFormValid() {
    return _textController.text.isNotEmpty && (_isSojuSelected || _isBeerSelected);
  }

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _charCount = _textController.text.length;
      });
    });
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          title: Text(
            "페이지 나가기",
            style: TextStyle(
              fontFamily: "NotoSansKR",
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            "작성한 내용은 저장되지 않아!",
            style: TextStyle(
              fontFamily: "NotoSansKR",
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그만 닫기
              },
              style: TextButton.styleFrom(
                side: BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                minimumSize: Size(120, 48),
              ),
              child: Text("계속 작성하기",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "NotoSansKR",
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                Navigator.pop(context); // 캘린더 화면으로 이동
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                minimumSize: Size(120, 48),
              ),
              child: Text("나가기",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "NotoSansKR",
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
              ),
            ),
          ],
        );
      },
    );
  }


  void _showSojuSelectionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "병", // ✅ "병"만 굵게
                        style: TextStyle(
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      TextSpan(
                        text: "으로 체크", // ✅ "으로 체크"는 일반 글씨
                        style: TextStyle(
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedSojuUnit = "병";
                    _isSojuSelected = true;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "잔", // ✅ "잔"만 굵게
                        style: TextStyle(
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      TextSpan(
                        text: "으로 체크",
                        style: TextStyle(
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedSojuUnit = "잔";
                    _isSojuSelected = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  void _showBeerSelectionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "병", // ✅ "병"만 굵게
                        style: TextStyle(
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      TextSpan(
                        text: "으로 체크", // ✅ "으로 체크"는 일반 글씨
                        style: TextStyle(
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedBeerUnit = "병";
                    _isBeerSelected = true;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "잔", // ✅ "잔"만 굵게
                        style: TextStyle(
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      TextSpan(
                        text: "으로 체크",
                        style: TextStyle(
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedBeerUnit = "잔";
                    _isBeerSelected = true;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "캔", // ✅ "캔"만 굵게
                        style: TextStyle(
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      TextSpan(
                        text: "으로 체크",
                        style: TextStyle(
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedBeerUnit = "캔";
                    _isBeerSelected = true;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "500ml", // ✅ "500ml"만 굵게
                        style: TextStyle(
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      TextSpan(
                        text: "로 체크",
                        style: TextStyle(
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedBeerUnit = "500ml";
                    _isBeerSelected = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog({required bool isSoju}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          title: Text(
            "술 삭제하기",
            style: TextStyle(
              fontFamily: "NotoSansKR",
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          content: Text(
            "입력한 내용을 삭제할까?",
            style: TextStyle(
              fontFamily: "NotoSansKR",
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        side: BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        minimumSize: Size(double.infinity, 48),
                      ),
                      child: Text(
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
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (isSoju) {
                            // ✅ 소주 삭제
                            _selectedSojuUnit = null;
                            _isSojuSelected = false;
                            _sojuAmount = 1.0;
                          } else {
                            // ✅ 맥주 삭제
                            _selectedBeerUnit = null;
                            _isBeerSelected = false;
                            _beerAmount = 1.0;
                          }
                        });
                        Navigator.pop(context); // 팝업 닫기
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        minimumSize: Size(double.infinity, 48),
                      ),
                      child: Text(
                        "삭제",
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
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitDialog();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            "음주 기록",
            style: TextStyle(
              fontFamily: "NotoSansKR",
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _showExitDialog,
            ),
          ],
        ),
        body: GestureDetector( // ✅ 화면 탭하면 키보드 닫기
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus(); // ✅ 키보드 닫기
          }, // GestureDetector onTap
          child: Column( // ✅ 전체 화면을 감싸는 Column
            children: [
              Expanded( // ✅ 키보드가 올라와도 내용이 사라지지 않도록 Expanded 사용
                child: SingleChildScrollView( // ✅ 키보드 올라오면 스크롤 가능하게 함
                  child: Column( // ✅ 스크롤 가능한 내부 콘텐츠
                    children: [
                      Padding( // ✅ "오늘의 기록" 입력란
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container( // ✅ 입력 필드 스타일 (둥근 테두리 & 그림자)
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
                              ), // BoxDecoration
                              child: Stack( // ✅ 텍스트 필드 & 글자 수 카운트 겹쳐서 배치
                                children: [
                                  TextField( // ✅ "오늘의 기록" 입력 필드
                                    controller: _textController,
                                    maxLength: 20,
                                    onChanged: (text) {
                                      setState(() {}); // ✅ 텍스트 입력 시 UI 업데이트
                                    }, // TextField onChanged
                                    decoration: InputDecoration(
                                      hintText: "오늘의 기록",
                                      hintStyle: TextStyle(
                                        fontFamily: "NotoSansKR",
                                        color: Colors.grey[400],
                                      ), // TextStyle
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      border: InputBorder.none,
                                      counterText: "",
                                    ), // InputDecoration
                                    cursorColor: Colors.black,
                                  ), // TextField
                                  Positioned( // ✅ 글자 수 카운트 표시
                                    right: 12,
                                    bottom: 10,
                                    child: Text(
                                      "$_charCount/20",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ), // TextStyle
                                    ), // Text
                                  ), // Positioned
                                ], // children (Stack)
                              ), // Stack
                            ), // Container
                          ], // children (Column)
                        ), // Column
                      ), // Padding

                      SizedBox(height: 20), // ✅ 위아래 여백 확보

                      Container( // ✅ 소주/맥주 선택 영역
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        padding: EdgeInsets.all(16),
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
                        ), // BoxDecoration
                        child: Column( // ✅ 소주/맥주 선택 UI
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "얼마나 마셨어?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ), // TextStyle
                            ), // Text
                            SizedBox(height: 15), // ✅ 여백 추가
                            Row( // ✅ 소주/맥주 선택 버튼
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildDrinkButton("소주", "assets/soju.png",
                                    _isSojuSelected ? () => _showDeleteDialog(isSoju: true) : _showSojuSelectionSheet,
                                    _isSojuSelected), // 소주 버튼
                                SizedBox(width: 80), // ✅ 버튼 사이 간격
                                _buildDrinkButton("맥주", "assets/beer.png",
                                    _isBeerSelected ? () => _showDeleteDialog(isSoju: false) : _showBeerSelectionSheet,
                                    _isBeerSelected), // 맥주 버튼
                              ], // children (Row)
                            ), // Row

                            if (_selectedSojuUnit != null)
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100], // 회색 박스
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset("assets/soju.png", width: 50, height: 50),
                                      SizedBox(width: 8),
                                      Text("소주 ($_selectedSojuUnit)"),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          setState(() {
                                            if (_sojuAmount > 0.5) _sojuAmount -= 0.5;
                                          });
                                        },
                                      ),
                                      Text("$_sojuAmount"),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            _sojuAmount += 0.5;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            if (_selectedBeerUnit != null)
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset("assets/beer.png", width: 50, height: 50),
                                      SizedBox(width: 8),
                                      Text("맥주 ($_selectedBeerUnit)"),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          setState(() {
                                            if (_beerAmount > 0.5) _beerAmount -= 0.5;
                                          });
                                        },
                                      ),
                                      Text("$_beerAmount"),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            _beerAmount += 0.5;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ], // children (Column)
                        ), // Column
                      ), // Container (소주/맥주 선택)

                      SizedBox(height: 20), // ✅ 하단 여백 추가
                    ], // children (Column)
                  ), // Column
                ), // SingleChildScrollView
              ), // Expanded

              Container( // ✅ "완료" 버튼
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isFormValid()
                      ? () {
                    Navigator.pop(context);
                  } : null, // ✅ 조건 충족 시 버튼 활성화
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey[500],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  ), // ElevatedButton 스타일
                  child: Text(
                    "완료",
                    style: TextStyle(
                      fontFamily: "NotoSansKR",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ), // TextStyle
                  ), // Text
                ), // ElevatedButton
              ), // Container (완료 버튼)

            ], // children (Column)
          ), // Column
        ), // GestureDetector
      ),
    );
  }

  Widget _buildDrinkButton(String label, String assetPath, VoidCallback onTap, bool isSelected) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: isSelected ? Color(0xFFF2D027) : Color(0xFFECECEC),
            child: Image.asset(assetPath, width: 32, height: 32),
          ),
          SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }
}