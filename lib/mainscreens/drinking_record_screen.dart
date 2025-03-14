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

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _charCount = _textController.text.length;
      });
    });
  }

  void _showUnitSelectionSheet() {
    showModalBottomSheet(
      context: context,
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
                title: Text("병으로 체크"),
                onTap: () {
                  setState(() {
                    _selectedSojuUnit = "병";
                    _isSojuSelected = true;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("잔으로 체크"),
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

  void _showDeleteDialog() {
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
              fontWeight: FontWeight.w700,),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 10), // 네모칸 더 길게
          content: Text(
              "입력한 내용을 삭제하겠어?",
              style: TextStyle(
                fontFamily: "NotoSansKR",
                fontSize: 15,
                fontWeight: FontWeight.w500,),
          ),
          actions: [
            SizedBox(
              width: double.infinity, // 버튼이 길어지도록 설정
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 닫기 버튼 → 유지
                      },
                      style: TextButton.styleFrom(
                        side: BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        minimumSize: Size(double.infinity, 48), // 길고 얇게 설정
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
                  SizedBox(width: 8), // 버튼 간 간격
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedSojuUnit = null;
                          _isSojuSelected = false;
                          _sojuAmount = 1.0; // 🎯 삭제하면 소주 잔 수도 초기화
                        });
                        Navigator.pop(context); // 팝업 닫기
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        minimumSize: Size(double.infinity, 48), // 길고 얇게 설정
                      ),
                      child: Text(
                        "삭제",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "NotoSansKR",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ), // 글씨 색상을 흰색으로 강제 지정
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
      onWillPop: () async => true,
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          TextField(
                            controller: _textController,
                            maxLength: 20,
                            decoration: InputDecoration(
                              hintText: "오늘의 기록",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              counterText: "",
                            ),
                            cursorColor: Colors.black,
                          ),
                          Positioned(
                            right: 12,
                            bottom: 10,
                            child: Text(
                              "$_charCount/20",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "얼마나 마셨어?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDrinkButton("소주", "assets/soju.png", _isSojuSelected ? _showDeleteDialog : _showUnitSelectionSheet, _isSojuSelected),
                        SizedBox(width: 60),
                        _buildDrinkButton("맥주", "assets/beer.png", () {}, false),
                      ],
                    ),
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
                                    if (_sojuAmount > 1.0) _sojuAmount -= 1.0;
                                  });
                                },
                              ),
                              Text("$_sojuAmount"),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    _sojuAmount += 1.0;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                height: 50,
                color: Color(0xFFF8F8F8),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "완료",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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