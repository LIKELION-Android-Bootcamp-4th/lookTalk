import 'package:flutter/material.dart';

class ProductTabViewModel extends ChangeNotifier {
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners(); // 탭 변경되었음을 알림 → 화면이 다시 빌드됨
    }
  }
}
