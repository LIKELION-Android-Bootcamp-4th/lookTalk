import 'package:flutter/material.dart';

class CommunityTabViewModel with ChangeNotifier {
  int _currentTabIndex = 0;
  int _previousTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  bool didClickSameTab() {
    return _currentTabIndex == _previousTabIndex;
  }
}
