import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  /// Currently selected notice item index to control its color
  int _selectedNoticeIndex = 0;
  int get selectedNoticeIndex => _selectedNoticeIndex;
  set selectedNoticeIndex(int value) {
    _selectedNoticeIndex = value;
  }
}
