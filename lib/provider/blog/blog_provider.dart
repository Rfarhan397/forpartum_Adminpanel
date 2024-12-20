import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forpartum_adminpanel/model/res/constant/app_utils.dart';
import 'package:provider/provider.dart';
import '../../model/res/constant/app_assets.dart';
import '../action/action_provider.dart';

class BlogPostProvider extends ChangeNotifier {
  List<Map<String, String>> _posts = [];

  List<String> _categories = [];
  List<String> _categoriesIds = [];
  List<String> _mealCategories = [];
  List<Map<String, String>> _filteredPosts = [];
  int _currentPage = 1;
  //for user screen//pagination
  int _currentUserPage = 1;
  int get currentUserPage => _currentUserPage;
  void goToUserPage(int page) {
    _currentUserPage = page;
    notifyListeners(); // This is important to update the UI when the page changes
  }




  final int _postsPerPage = 12;

  bool _isUpdate = false;
  String _id = "";

  bool get isUpdate => _isUpdate;
  String get id => _id;

  void setUpdate(bool value,String id) {
    _isUpdate = value;
    _id = id;
    notifyListeners();
  }

  BlogPostProvider() {
    fetchBlog();
  }

  List<Map<String, String>> get posts => _posts;
  List<String> get categories => _categories;
  List get categoriesIds => _categoriesIds;
  List<String> get mealCategories => _mealCategories;


  List<Map<String, String>> get filteredPosts {
    final startIndex = (_currentPage - 1) * _postsPerPage;
    final endIndex = startIndex + _postsPerPage;
    return _filteredPosts.sublist(
        startIndex,
        endIndex > _filteredPosts.length ? _filteredPosts.length : endIndex
    );
  }

  int get currentPage => _currentPage;

  int get totalPages => (_filteredPosts.length / _postsPerPage).ceil();

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      _currentPage = page;
      notifyListeners();
    }
  }

  void filterPostsByCategory(String category) {
    if (category == 'All') {
      // Show all posts when "All" is selected
      _filteredPosts = _posts;
    } else {
      _filteredPosts = _posts.where((post) {
        final postCategory = post['category']?.trim().toLowerCase();
        final selectedCategory = category.trim().toLowerCase();
        log("Post category: $postCategory, Selected category: $selectedCategory");
        return postCategory == selectedCategory;
      }).toList();
    }
    _currentPage = 1;  // Reset to the first page when filtering
    notifyListeners();
  }


  Future<void> fetchBlog() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('blogs').get();
      _posts = snapshot.docs.map((doc) => {
        'imageUrl': (doc['imageUrl'] ?? AppAssets.yoga).toString(),
        'title': (doc['title'] ?? 'No Title').toString(),
        'category': (doc['category'] ?? 'Uncategorized').toString(),
        'readTime': (doc['readTime'] ?? 'Unknown').toString(),
        'content': (doc['content'] ?? 'Unknown').toString(),
      }).toList();

      _filteredPosts = _posts;  // Initialize filteredPosts with all posts
      notifyListeners();
    } catch (e) {
      log("Error fetching posts: $e");
    }
  }
  Future<void> fetchMealCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('mealCategory').get();
      _mealCategories = snapshot.docs.map((doc) => doc['mealCategory'] as String).toList();
      var _categoriesID = snapshot.docs.map((doc) => doc.id).toList();
      log('meal categories are: ${_mealCategories}');
      log('meal categories Id are: ${_categoriesID}');
      // Ensure "All" is only added once
      if (!_mealCategories.contains("All")) {
        _mealCategories.insert(0, "All");
      }
      notifyListeners();
    } catch (e) {
      log("Error fetching categories: $e");
    }
  }
  Future<void> fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('blogsCategory').orderBy(
        'createdAt' , descending: false
      ).get();
      _categories = snapshot.docs.map((doc) => doc['category'] as String).toList();
       _categoriesIds = snapshot.docs.map((doc) => doc.id).toList();
      log('Fetched categories: ${categories.toString()}');
      log('categories are: ${_categories}');
      log('categoriesId are: ${_categoriesIds}');

      notifyListeners();
    } catch (e) {
      log("Error fetching categories: $e");
    }
  }
  Future<void> fetchLearningCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('learningCategories').orderBy(
        'createdAt' , descending: false
      ).get();
      _categories = snapshot.docs.map((doc) => doc['category'] as String).toList();
       _categoriesIds = snapshot.docs.map((doc) => doc.id).toList();
      log('Fetched categories: ${categories.toString()}');
      log('categories are: ${_categories}');
      log('categoriesId are: ${_categoriesIds}');

      notifyListeners();
    } catch (e) {
      log("Error fetching categories: $e");
    }
  }

  void updateCategory(BuildContext context, String id,String name) async {
    try {
      log('Updating category...');
      await FirebaseFirestore.instance
          .collection('blogsCategory')
          .doc(id)
          .update({
        'category': name,
      });

      log('Category updated successfully');
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Category Updated');
      setUpdate(false, "");
    } catch (e) {
      log('Failed to update category: $e');
      AppUtils().showToast(text: 'Failed to update category');
    }
  }
  void updateMealCategory(BuildContext context, String id,String name) async {
    try {
      log('Updating category...');
      await FirebaseFirestore.instance
          .collection('mealCategory')
          .doc(id)
          .update({
        'mealCategory': name,
      });

      log('Category updated successfully');
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Category Updated');
      setUpdate(false, "");
    } catch (e) {
      log('Failed to update category: $e');
      AppUtils().showToast(text: 'Failed to update category');
    }
  }
  void updateLearningCategory(BuildContext context, String id,String name) async {
    try {
      log('Updating category...');
      await FirebaseFirestore.instance
          .collection('learningCategories')
          .doc(id)
          .update({
        'category': name,
      });

      log('Category updated successfully');
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Category Updated');
      setUpdate(false, "");
    } catch (e) {
      log('Failed to update category: $e');
      AppUtils().showToast(text: 'Failed to update category');
    }
  }

  void deleteCategory(context,String id) async{
    await FirebaseFirestore.instance.collection('blogsCategory').doc(id).delete();
    AppUtils().showToast(text: 'category deleted successfully');
  }

  void deleteMealCategory(context,String id) async{
    await FirebaseFirestore.instance.collection('mealCategory').doc(id).delete();
    AppUtils().showToast(text: 'category deleted successfully');
  }


  void deleteLearningCategory(context,String id) async{
    await FirebaseFirestore.instance.collection('learningCategories').doc(id).delete();
    AppUtils().showToast(text: 'category deleted successfully');
  }
  /////length of meals//////////

  int _totalDocuments = 0;
  int _recommendedDocuments = 0;

  int get totalDocuments => _totalDocuments;
  int get recommendedDocuments => _recommendedDocuments;

  int _totalUsersWhoTookMeals = 0;
  int get totalUsersWhoTookMeals => _totalUsersWhoTookMeals;

  Future<void> fetchDocumentCounts() async {
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('addMeal');

    // Get the total number of documents
    QuerySnapshot allDocumentsSnapshot = await collectionRef.get();
    _totalDocuments = allDocumentsSnapshot.docs.length;
    log('Total documents count: $_totalDocuments');

    // Get the number of documents where 'recommended' is true
    QuerySnapshot recommendedSnapshot = await collectionRef.where('recommended', isEqualTo: 'yes').get();
    _recommendedDocuments = recommendedSnapshot.docs.length;
    log('Recommended documents count: $_recommendedDocuments');


    // Count the total number of unique users who took the meals
    Set<String> uniqueUsers = Set<String>(); // Set to store unique user uids
    for (var doc in allDocumentsSnapshot.docs) {
      // Safely get the data as Map<String, dynamic>
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Get the 'meals' field safely
      var mealsField = data['meals'];

      // Check if 'meals' is a List, otherwise skip this document
      if (mealsField is List) {
        List<dynamic> meals = mealsField;
        log('Meals for document ${doc.id}: $meals'); // Log the meals array

        for (var userUid in meals) {
          uniqueUsers.add(userUid);  // Add userUid to the set (duplicates will be ignored)
        }
      } else {
        log('No valid meals field found or meals is not a list in document ${doc.id}');
      }
    }

    _totalUsersWhoTookMeals = uniqueUsers.length;
    log('Total unique users who took meals: $_totalUsersWhoTookMeals');

    // Notify listeners to update the UI
    notifyListeners();
  }



}
