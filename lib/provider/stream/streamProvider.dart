import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:forpartum_adminpanel/model/user_model/user_model.dart';

import '../../model/blog_post/blog_model.dart';
import '../../model/tracker/trackerModel.dart';

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
  Stream<List<TrackerQuestionModel>> getTrackerLog({int? limit, required String type}) {
    Query query =  FirebaseFirestore.instance.collection("trackerLog");
    if (limit != null) {
      query = query.limit(limit);
    }

    if(type.isNotEmpty){
      query = query.where("type",isEqualTo: type);
    }


    return query.snapshots().asyncMap((snapshot) async {
      final questionWithOptions = await Future.wait(snapshot.docs.map((doc) async {
        final questionData = doc.data() as Map<String, dynamic>;
        final question = TrackerQuestionModel.fromMap(questionData);

        // Fetch options for the current question
        final optionsSnapshot = await  FirebaseFirestore.instance.collection("trackerLog")
            .doc(doc.id) // Use the document ID of the current question
            .collection('options') // Assuming options are in a sub-collection named 'options'
            .get();

        if (optionsSnapshot.docs.isNotEmpty) {
          question.optionModel = optionsSnapshot.docs
              .map((optionDoc) => TrackerOptionModel.fromMap(optionDoc.data()))
              .toList();
        }
        return question;
      }).toList());
      return questionWithOptions;
    });
  }
  Stream<QuerySnapshot> getStressOptionsStream({String? type}) {
    Query query = FirebaseFirestore.instance
        .collection("trackerLog");

    if (type != null && type.isNotEmpty) {
      query = query.where('type', isEqualTo: type);
    }
    return query.snapshots();
  }


  Stream<List<Tracker>> getTrackerLogs({int? limit, String? type,required String uid}) {
    Query query = FirebaseFirestore.instance
          .collection("users").doc(uid).collection("tracker");
    if (limit != null) {
      query = query.limit(limit);
    }
    if (type != null && type.isNotEmpty) {
          query = query.where('type', isEqualTo: type);
        }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Tracker.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
  Stream<List<Admin>> getAdminStream() {
    // Replace this with your actual stream source, such as a Firestore collection.
    return FirebaseFirestore.instance.collection('admin').snapshots().map((snapshot) {
     return snapshot.docs.map((doc) {
        return Admin.fromMap(doc.data());
      }).toList();
    });
  }
  Stream<List<MilestoneModel>> getMilestone({String? userUid,int? limit, bool? isComplete, }) {
    Query query = FirebaseFirestore.instance.collection("milestones");

    if (limit != null) {
      query = query.limit(limit);
    }

    if (isComplete != null && isComplete) {
      query = query.where("milestones", arrayContains: userUid);
    }
    return query.snapshots().map((snapshot) {
      List<MilestoneModel> milestones = snapshot.docs.map((doc) {
        return MilestoneModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return milestones;
    });
  }

}