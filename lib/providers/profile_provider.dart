import 'package:flutter/material.dart';
import 'dart:io';

class ProfileProvider with ChangeNotifier {
  String _nickname = '정해인';
  File? _imageFile;

  // ✅ 추가: 주량 정보와 다짐 정보
  String? _drinkType;
  double? _drinkAmount;
  int? _pledgeLimit;

  String get nickname => _nickname;
  File? get imageFile => _imageFile;

  String? get drinkType => _drinkType;
  double? get drinkAmount => _drinkAmount;
  int? get pledgeLimit => _pledgeLimit;

  void updateNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners();
  }

  void updateImage(File newImage) {
    _imageFile = newImage;
    notifyListeners();
  }

  // ✅ 추가: 주량 업데이트
  void updateDrinkingInfo(String type, double amount) {
    _drinkType = type;
    _drinkAmount = amount;
    notifyListeners();
  }

  // ✅ 추가: 다짐 한도 업데이트
  void updatePledgeLimit(int limit) {
    _pledgeLimit = limit;
    notifyListeners();
  }
}