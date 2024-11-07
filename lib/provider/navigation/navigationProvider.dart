import 'package:flutter/cupertino.dart';

class NavigationProvider with ChangeNotifier {
  int _selectedIndex = 0;
  int _hoveredIndex = -1;

  int get selectedIndex => _selectedIndex;
  int get hoveredIndex => _hoveredIndex;

  void selectScreen(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setHoveredIndex(int index) {
    _hoveredIndex = index;
    notifyListeners();
  }
}

class ActivityLogProvider with ChangeNotifier {
  List<String> _logs = List.generate(100, (index) => '06-25-2024');

  int _currentPage = 1;
  final int _itemsPerPage = 20;

  List<String> get logsForPage {
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = start + _itemsPerPage;
    return _logs.sublist(start, end);
  }

  int get totalPages => (_logs.length / _itemsPerPage).ceil();
  int get currentPage => _currentPage;

  void goToPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

}
