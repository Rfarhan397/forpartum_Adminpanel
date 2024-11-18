import 'package:flutter/material.dart';

class DropdownProvider with ChangeNotifier {
  String _selectedValue = 'Last 30 Days';
  String _selectedCategory = 'Dietary Category';
  String _selectedStatusCategory = 'Status';
  String _selectedMealCategory = 'Meal Plan Duration';
  String _selectedBlogCategory = 'Category';

  bool _isDropdownOpen = false;
  bool _isUpdate = false;

  String get selectedValue => _selectedValue;
  String get selectedCategory => _selectedCategory;
  String get selectedStatusCategory => _selectedStatusCategory;
  String get selectedMealCategory => _selectedMealCategory;
  String get selectedBlogCategory => _selectedBlogCategory;
  bool get isDropdownOpen => _isDropdownOpen;
  bool get isUpdate => _isUpdate;

  void toggleDropdown() {
    _isDropdownOpen = !_isDropdownOpen;
    notifyListeners();
  }

  void toggleUpdate(bool update) {
    _isUpdate =  update;
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _isDropdownOpen = false;
    notifyListeners();
  }

  void setSelectedValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }
}

class DropdownProviderN with ChangeNotifier {
  String _selectedOption = "Monthly"; // Default option
  String _selectedCategory = "Category"; // Default option
  String _selectedCategoryId = ""; // Default option
  String _selectedLanguage = "English"; // Default option
  String _selectedTimeZone = "Mountain Time"; // Default option
  String _selectedType = "Type"; // Default option
  String _selectedDietaryCategory = "Dietary Category"; // Default option
  String _selectedStatus = "Status"; // Default option
  String _selectedMealPlanDuration = "Meal Plan Duration"; // Default option
  Map<int, bool> _dropdownVisibility = {}; // Track visibility for each dropdown by index

  String get selectedOption => _selectedOption;
  String get selectedCategory => _selectedCategory;
  String get selectedCategoryId => _selectedCategoryId;
  String get selectedLanguage => _selectedLanguage;
  String get selectedTimeZone => _selectedTimeZone;
  String get selectedType => _selectedType;
  String get selectedDietaryCategory => _selectedDietaryCategory;
  String get selectedStatus => _selectedStatus;
  String get selectedMealPlanDuration => _selectedMealPlanDuration;

  bool isDropdownVisible(int index) => _dropdownVisibility[index] ?? false;

  void setSelectedOption(String option) {
    _selectedOption = option;
    notifyListeners();
  }

  void setSelectedLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  void setSelectedTimeZone(String timeZone) {
    _selectedTimeZone = timeZone;
    notifyListeners();
  }

  void setSelectedType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  void setSelectedCategory(String category, String id) {
    _selectedCategory = category;
    _selectedCategoryId = id;
    notifyListeners();
  }

  void setSelectedDietaryCategory(String dietaryCategory) {
    _selectedDietaryCategory = dietaryCategory;
    notifyListeners();
  }

  void setSelectedStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void setSelectedMealPlanDuration(String mealPlanDuration) {
    _selectedMealPlanDuration = mealPlanDuration;
    notifyListeners();
  }

  void toggleDropdownVisibility(int index) {
    // Close all other dropdowns
    closeOtherDropdowns(index);

    // Toggle the selected dropdown's visibility
    _dropdownVisibility[index] = !(isDropdownVisible(index));
    notifyListeners();
  }

  void closeOtherDropdowns(int index) {
    _dropdownVisibility.forEach((key, value) {
      if (key != index) {
        _dropdownVisibility[key] = false;
      }
    });
  }
}
