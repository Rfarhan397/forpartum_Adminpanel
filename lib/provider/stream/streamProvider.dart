import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../model/blog_post/blog_model.dart';

class StreamDataProvider extends ChangeNotifier{


  Stream<List<BlogCategory>> getBlogCategory() {
    // String? userUID = auth.currentUser?.uid.toString();
    return FirebaseFirestore.instance.collection('blogsCategory').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BlogCategory.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<BlogPost>> getBlog() {
    // String? userUID = auth.currentUser?.uid.toString();
    return FirebaseFirestore.instance.collection('blogs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BlogPost.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<BlogPost>> getBlogFilter({required String categoryId}) {
    // String? userUID = auth.currentUser?.uid.toString();
    return FirebaseFirestore.instance.collection('blogs')
        .where("categoryId", isEqualTo: categoryId)
        .snapshots().map((snapshot) {
          log('category is is::${categoryId}');
      return snapshot.docs.map((doc) {
        return BlogPost.fromMap(doc.data());
      }).toList();
    });
  }


  //this is for getting meal categories from firebase
  Stream<List<AddMealCategory>> getMealPlanCategories() {
    // String? userUID = auth.currentUser?.uid.toString();
    return FirebaseFirestore.instance.collection('mealCategory').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AddMealCategory.fromMap(doc.data());
      }).toList();
    });
  }


  Stream<List<AddMeal>> getMealPlan() {
    // String? userUID = auth.currentUser?.uid.toString();
    return FirebaseFirestore.instance.collection('addMeal').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AddMeal.fromMap(doc.data());
      }).toList();
    });
  }

}