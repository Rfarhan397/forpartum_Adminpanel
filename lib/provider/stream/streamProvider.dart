import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:forpartum_adminpanel/model/user_model/user_model.dart';

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
  //this is for getting learning categories from firebase
  Stream<List<AddLearningCategory>> getLearningCategories() {
    // String? userUID = auth.currentUser?.uid.toString();
    return FirebaseFirestore.instance.collection('learningCategories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AddLearningCategory.fromMap(doc.data());
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
  Stream<List<AddMilestone>> getMilestones() {
    // String? userUID = auth.currentUser?.uid.toString();
    return FirebaseFirestore.instance.collection('milestones').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AddMilestone.fromMap(doc.data());
      }).toList();
    });
  }
  Stream<List<AddGuideline>> getGuideline() {
    // String? userUID = auth.currentUser?.uid.toString();
    return FirebaseFirestore.instance.collection('guideline').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AddGuideline.fromMap(doc.data());
      }).toList();
    });
  }
  Stream<List<User>> getUsers() {
    // String? userUID = auth.currentUser?.uid.toString();
    return FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return User.fromMap(doc.data());
      }).toList();
    });
  }

}