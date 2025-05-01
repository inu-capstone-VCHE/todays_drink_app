import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:todays_drink/providers/profile_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  File? _image;
  bool _isEditingName = false;
  String _nickname = '닉네임';
  final TextEditingController _nicknameController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        Provider.of<ProfileProvider>(context, listen: false).updateImage(_image!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _nicknameController.text = profileProvider.nickname;
    _nickname = profileProvider.nickname;
    _image = profileProvider.imageFile;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditingName = true;
      _nicknameController.text = _nickname;
    });
  }

  void _saveNickname() {
    Provider.of<ProfileProvider>(context, listen: false)
        .updateNickname(_nicknameController.text);
    setState(() {
      _nickname = _nicknameController.text;
      _isEditingName = false;
    });
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
              _isEditingName
                  ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nicknameController,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _saveNickname,
                    style: TextButton.styleFrom(
                      foregroundColor: mainColor,
                    ),
                    child: const Text("저장"),
                  ),
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _nickname,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _startEditing,
                    child: const Icon(Icons.edit, size: 20, color: Color(0xfff2c12e)),
                  ),
                ],
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
                  const SizedBox(width: 6),
                  const Icon(Icons.edit, size: 18, color: Color(0xfff2c12e)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('주량', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(width: 20),
                  Consumer<ProfileProvider>(
                    builder: (_, provider, __) {
                      if (provider.drinkType == null || provider.drinkAmount == null) {
                        return const Text('정보 없음', style: TextStyle(fontSize: 16));
                      }
                      return Text(
                        '${provider.drinkType} ${provider.drinkAmount!.toStringAsFixed(1)}병',
                        style: const TextStyle(fontSize: 16),
                      );
                    },
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
                    child: Consumer<ProfileProvider>(
                      builder: (_, provider, __) {
                        if (provider.pledgeLimit == null) {
                          return const Text('정보 없음', style: TextStyle(fontSize: 16));
                        }
                        return Text(
                          '한 달 동안 ${provider.pledgeLimit}병 이상 마시지 않기',
                          style: const TextStyle(fontSize: 16),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {}, child: const Text('로그아웃')),
                  const Text('|', style: TextStyle(color: Colors.grey)),
                  TextButton(onPressed: () {}, child: const Text('회원 탈퇴')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
