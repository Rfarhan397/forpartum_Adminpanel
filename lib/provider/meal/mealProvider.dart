import 'dart:typed_data';
import 'package:flutter/material.dart';

class MealProvider with ChangeNotifier {
  String? _selectedMealType;
  String? _selectedCategory;
  String? _selectedDays;
  String? selectedRecommended;
  Uint8List? _mealImage;

  String? get selectedMealType => _selectedMealType;
  String? get selectedCategory => _selectedCategory;
  String? get selectedDays => _selectedDays;
  Uint8List? get mealImage => _mealImage;

  void setMealType(String mealType) {
    _selectedMealType = mealType;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
  void setDays(String days) {
    _selectedDays = days;
    notifyListeners();
  }

  void setMealImage(Uint8List image) {
    _mealImage = image;
    notifyListeners();
  }
  void setRecommended(String value) {
    selectedRecommended = value;
    notifyListeners();
  }

  void clearMealData() {
    _selectedMealType = '' ;
    _selectedCategory = '';
    _selectedDays  = '';
    _mealImage ;
    notifyListeners();
  }

  //App Content disclaimer
  String? selectedDisclaimer;

  void setDisclaimer(String value) {
    selectedDisclaimer = value;
    notifyListeners();
  }

  void clearDisclaimer() {
    selectedDisclaimer = null;
    notifyListeners();
  }
}
