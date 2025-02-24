import 'package:flutter/material.dart';

class DrinkingRecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop에서 true를 반환하면 기본 뒤로가기 동작(즉, 현재 화면 pop)이 실행됩니다.
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("음주 기록"),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        // GestureDetector에 behavior: HitTestBehavior.translucent 를 추가하여
        // 자식 위젯(여기서는 TextField)의 터치 이벤트가 막히지 않도록 함
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "오늘의 기록",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Text("얼마나 마셨어?"),
              // 추가 UI 구현 가능
            ],
          ),
        ),
      ),
    );
  }
}
