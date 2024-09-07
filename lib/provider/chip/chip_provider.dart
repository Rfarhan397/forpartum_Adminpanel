import 'package:flutter/material.dart';

class ChipProvider with ChangeNotifier {
  String _selectedCategory = 'All';
  String _hoveredCategory = '';

  String get selectedCategory => _selectedCategory;
  String get hoveredCategory => _hoveredCategory;

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setHoveredCategory(String category) {
    _hoveredCategory = category;
    notifyListeners();
  }

  void clearHoveredCategory() {
    _hoveredCategory = '';
    notifyListeners();
  }
}
