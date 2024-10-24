import 'package:flutter/material.dart';

class ChipProvider with ChangeNotifier {
  String _selectedCategory = 'All';
  String? _selectedCategoryId ;
  String _hoveredCategory = '';

  String get selectedCategory => _selectedCategory;
  String? get selectedCategoryId => _selectedCategoryId;
  String get hoveredCategory => _hoveredCategory;

  void selectCategory( String category) {
    _selectedCategory = category;
    notifyListeners();
  }
  void selectCategoryId( String categoryId) {
    _selectedCategoryId = categoryId;
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
