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
    'Disclaimer',

  ];

  int _currentPage = 0;
  final int _itemsPerPage = 8;

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
  List<bool> expanded = [];

  void toggleExpand(int index) {
    if (index < expanded.length) {
      expanded[index] = !expanded[index];
      notifyListeners();
    }
  }

  void updateExpandedList(int newLength) {
    if (newLength > expanded.length) {
      expanded.addAll(List.generate(newLength - expanded.length, (index) => false));
    } else if (newLength < expanded.length) {
      expanded = expanded.sublist(0, newLength);
    }
    notifyListeners();
  }
  void initializeExpandedList(int itemCount) {
    if (expanded.length != itemCount) {
      expanded = List<bool>.filled(itemCount, false);
      notifyListeners();
    }
  }

  void toggleExpandd(int index) {
    expanded[index] = !expanded[index];
    notifyListeners();
  }
}
