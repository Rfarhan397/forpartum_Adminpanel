import 'package:flutter/material.dart';

class CardProvider with ChangeNotifier {
  final List<String> _titles = [
    'CBT Sessions',
    'Milestone',
    'Tackers'
  ];

  int _currentPage = 0;
  final int _itemsPerPage = 7;

  List<String> get currentCards {
    int start = _currentPage * _itemsPerPage;
    int end = (start + _itemsPerPage).clamp(0, _titles.length);
    return _titles.sublist(start, end);
  }

  int get totalPages => (_titles.length / _itemsPerPage).ceil();

  int get currentPage => _currentPage + 1;

  void goToPage(int page) {
    if (page - 1 < totalPages && page > 0) {
      _currentPage = page - 1;
      notifyListeners();
    }
  }
}
class CardProviderMenu with ChangeNotifier {
  final List<String> _titles = [
    'FAQ',
    'Privacy',
    'Terms & Conditions',
    'Settings',
  ];

  int _currentPage = 0;
  final int _itemsPerPage = 4;

  List<String> get currentCards {
    int start = _currentPage * _itemsPerPage;
    int end = (start + _itemsPerPage).clamp(0, _titles.length);
    return _titles.sublist(start, end);
  }

  int get totalPages => (_titles.length / _itemsPerPage).ceil();

  int get currentPage => _currentPage + 1;

  void goToPage(int page) {
    if (page - 1 < totalPages && page > 0) {
      _currentPage = page - 1;
      notifyListeners();
    }
  }
}

class FaqProvider with ChangeNotifier {
  List<bool> _expanded = [false, false, false]; // Adjust according to your number of items
  List<bool> _expandedd = [false, false, false, false, false, false, false, false, false]; // Adjust according to your number of items

  List<bool> get expanded => _expanded;
  List<bool> get expandedd => _expandedd;

  void toggleExpand(int index) {
    _expanded[index] = !_expanded[index];
    notifyListeners();
  }
  void toggleExpandd(int index) {
    _expandedd[index] = !_expandedd[index];
    notifyListeners();
  }
}
