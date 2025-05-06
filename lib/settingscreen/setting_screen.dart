import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:todays_drink/providers/profile_provider.dart';
import 'package:todays_drink/launchscreen/start_screen2.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  File? _image;
  String _nickname = '';
  String? _drinkType;
  double? _drinkAmount;
  int? _monthGoal;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      setState(() {
        _image = profileProvider.imageFile;
      });

      final token = profileProvider.accessToken;
      await _fetchUserData(token!);
      await _fetchGoalData(token!);
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        Provider.of<ProfileProvider>(context, listen: false).updateImage(_image!);
      });
    }
  }

  Future<void> _fetchUserData(String token) async {
    final response = await http.get(
      Uri.parse('http://54.180.90.1:8080/user'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        _nickname = data['nickname'] ?? '닉네임';
      });
    } else {
      print('❌ 유저 닉네임 요청 실패: ${response.statusCode}');
    }
  }

  Future<void> _fetchGoalData(String token) async {
    final response = await http.get(
      Uri.parse('http://54.180.90.1:8080/goal/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print('🍺 타입: ${data['type']} / 카운트: ${data['count']} / 목표: ${data['month_goal']}');

      setState(() {
        _drinkType = data['type'];
        _drinkAmount = (data['count'] as num?)?.toDouble();
        _monthGoal = (data['month_goal'] as num?)?.toInt(); // 💥 여기 수정
      });

    } else {
      print('❌ 목표 정보 요청 실패: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF2E7B8C);

    return Theme(
      data: ThemeData(
        primaryColor: mainColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: mainColor,
          secondary: mainColor,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: mainColor,
          selectionColor: Color(0x332E7B8C),
          selectionHandleColor: mainColor,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            '내 프로필',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 17,
              fontFamily: "NotoSansKR",
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFFEFEFEF),
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.pets, size: 50, color: Colors.grey)
                          : null,
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.camera_alt, size: 16, color: Color(0xfff2c12e)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  _nickname,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        height: 11,
                        width: 64,
                        color: const Color(0xFFF2D027),
                      ),
                      const Text(
                        '나의 음주',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'NotoSansKR',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('주량', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(width: 20),
                  Text(
                    _drinkType != null && _drinkAmount != null
                        ? '${_drinkType == 'soju' ? '소주' : _drinkType == 'beer' ? '맥주' : _drinkType} ${_drinkAmount!.toStringAsFixed(1)}병'
                        : '정보 없음',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('목표', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      _monthGoal != null
                          ? '한 달 동안 $_monthGoal병 이상 마시지 않기'
                          : '정보 없음',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // 모든 상태 초기화
                      Provider.of<ProfileProvider>(context, listen: false).reset();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => StartScreen2()), // 걍 직접 써도 돼
                            (route) => false,
                      );
                    },
                    child: const Text('로그아웃'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
