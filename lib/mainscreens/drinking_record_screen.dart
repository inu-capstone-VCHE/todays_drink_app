import 'package:flutter/material.dart';

class DrinkingRecordScreen extends StatefulWidget {
  @override
  _DrinkingRecordScreenState createState() => _DrinkingRecordScreenState();
}

class _DrinkingRecordScreenState extends State<DrinkingRecordScreen> {
  TextEditingController _textController = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _charCount = _textController.text.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        appBar: AppBar(
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
                              hintStyle: TextStyle(
                                fontFamily: "NotoSansKR",
                                fontSize: 16,
                                color: Colors.grey, // 🔥 placeholder 회색
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14), // 🔥 높이 조정
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              counterText: "", // 🔥 "0/20" 중복 제거
                            ),
                            cursorColor: Colors.black,
                          ),
                          Positioned(
                            right: 12,
                            bottom: 10,
                            child: Text(
                              "$_charCount/20",
                              style: TextStyle(
                                fontFamily: "NotoSansKR",
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
              // 🔥 "얼마나 마셨어?" 네모칸 (오늘의 기록 네모랑 동일한 스타일)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // 🔥 그림자 추가
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
                        fontFamily: "NotoSansKR",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDrinkButton("소주", "assets/soju.png"),
                        SizedBox(width: 20), // 🔥 버튼 간격 넓힘
                        _buildDrinkButton("맥주", "assets/beer.png"),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "완료",
                    style: TextStyle(
                      fontFamily: "NotoSansKR",
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

  Widget _buildDrinkButton(String label, String assetPath) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200], // 🔥 배경 유지 (연한 회색)
          ),
          child: ClipOval(
            child: Padding(
              padding: EdgeInsets.all(7), // 🔥 이미지 크기 줄이기 (여백 추가)
              child: Image.asset(
                assetPath,
                width: 38, // 🔥 이미지 크기 조절
                height: 38,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 38, color: Colors.red);
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontFamily: "NotoSansKR",
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
