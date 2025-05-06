import 'package:flutter/material.dart';
import 'dart:io';

class ProfileProvider with ChangeNotifier {
  // ✅ 기본 프로필 정보
  String _nickname = '닉네임';
  File? _imageFile;

  // ✅ 주량 정보
  String? _drinkType;
  double? _drinkAmount;

  // ✅ 다짐 정보
  int? _pledgeLimit;

  // ✅ accessToken
  String? _accessToken;

  // ---------- Getters ----------
  String get nickname => _nickname;
  File? get imageFile => _imageFile;
  String? get drinkType => _drinkType;
  double? get drinkAmount => _drinkAmount;
  int? get pledgeLimit => _pledgeLimit;
  String? get accessToken => _accessToken;

  // ---------- Setters / Updaters ----------
  void updateNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners();
  }

  void updateImage(File newImage) {
    _imageFile = newImage;
    notifyListeners();
  }

  void updateDrinkingInfo(String type, double amount) {
    _drinkType = type;
    _drinkAmount = amount;
    notifyListeners();
  }

  void updatePledgeLimit(int limit) {
    _pledgeLimit = limit;
    notifyListeners();
  }

  void setAccessToken(String token) {
    _accessToken = token;
    notifyListeners();
  }

  void clearAccessToken() {
    _accessToken = null;
    notifyListeners();
  }
}
