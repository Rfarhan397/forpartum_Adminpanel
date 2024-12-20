import 'package:cloud_firestore/cloud_firestore.dart';

class BlogPost {
   final String imageUrl;
  final String title;
  final String category;
  final String readTime;
  final String content;
  final String createdAt;
  final String id;

  BlogPost({
    required this.imageUrl,
    required this.id,
    required this.title,
    required this.category,
    required this.readTime,
    required this.content,
    required this.createdAt,
  });


  factory BlogPost.fromMap(Map<String, dynamic> data) {
    return BlogPost(
      imageUrl: data['imageUrl'] ?? '',
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      readTime: data['readTime'] ?? '',
      content: data['content'] ?? '',
      id: data['id'] ?? '',
      createdAt: (data['createdAt']).toString(), // Convert Timestamp to DateTime
    );
  }
}


class BlogCategory{
  final String category;
  final String id;
  final String createdAt;


  BlogCategory( {
    required this.category,
    required this.id,
    required this.createdAt,

  });


  factory BlogCategory.fromMap(Map<String, dynamic> data) {
    return BlogCategory(
      category: data['category'] ?? '',
      id: data['id'] ?? '',
      createdAt: data['createdAt'] ?? '',

    );
  }
}
class AddMeal{
  final String? carbs;
  final String? mealType;
  final String? fat;
  final String? imageUrl;
  final String? name;
  final String? protein;
  final String? id;
  final String? createdAt;
  final String? recommended;
  final String? ingredients;
  final String? recipe;
  final String? deitary;
  final String? days;
  final String description;


  AddMeal({
     this.carbs,
     this.mealType,
     this.fat,
     this.imageUrl,
     this.name,
     this.protein,
     this.id,
     this.createdAt,
     this.recommended,
     this.ingredients,
     this.deitary,
     this.recipe,
     this.days,
     this.description = "",

  });


  factory AddMeal.fromMap(Map<String, dynamic> data) {
    return AddMeal(
      carbs: data['carbs'] ?? '',
      fat: data['fat'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      name: data['name'] ?? '',
      protein: data['protein'] ?? '',
      id: data['id'] ?? '',
      createdAt: data['createdAt'] ?? '',
      mealType: data['mealType'] ?? '',
      recommended: data['recommended']?? '',
      ingredients: data['ingredients'] ?? '',
      recipe: data['recipe'] ?? '',
      description: data['description'] ?? '',
      deitary: data['mealCategory'] ?? '',
      days: data['days'] ?? '',

    );
  }
}
class AddMealCategory{
  final String mealCategory;
  final String id;
  final String createdAt;


  AddMealCategory({
    required this.mealCategory,
    required this.id,
    required this.createdAt,

  });


  factory AddMealCategory.fromMap(Map<String, dynamic> data) {
    return AddMealCategory(
      mealCategory: data['mealCategory'] ?? '',

      id: data['id'] ?? '',
      createdAt: data['createdAt'] ?? '',

    );
  }
}
class AddLearningCategory{
  final String category;
  final String id;
  final String createdAt;


  AddLearningCategory({
    required this.category,
    required this.id,
    required this.createdAt,

  });


  factory AddLearningCategory.fromMap(Map<String, dynamic> data) {
    return AddLearningCategory(
      category: data['category'] ?? '',

      id: data['id'] ?? '',
      createdAt: data['createdAt'] ?? '',

    );
  }
}
class AddMilestone{
  final String title;
  final String id;
  final String createdAt;
  final String months;


  AddMilestone({
    required this.title,
    required this.id,
    required this.createdAt,
    required this.months,

  });


  factory AddMilestone.fromMap(Map<String, dynamic> data) {
    return AddMilestone(
      title: data['title'] ?? '',

      id: data['id'] ?? '',
      createdAt: data['createdAt'] ?? '',
      months: data['months'] ?? '',

    );
  }
}
class AddGuideline{
  final String question;
  final String answer;
  final String id;
  final String createdAt;


  AddGuideline({
    required this.question,
    required this.answer,
    required this.id,
    required this.createdAt,

  });


  factory AddGuideline.fromMap(Map<String, dynamic> data) {
    return AddGuideline(
      question: data['question'] ?? '',
      answer: data['answer'] ?? '',
      id: data['id'] ?? '',
      createdAt: data['createdAt'] ?? '',

    );
  }
}
class NotificationModel{
  final String description;
  final String message;
  final String timestamp;
  final String title;
  final String status;
  final String? id;


  NotificationModel({
    required this.description,
    required this.message,
    required this.timestamp,
    required this.title,
     this.id,
    required this.status,

  });


  factory NotificationModel.fromMap(Map<String, dynamic> data) {
    return NotificationModel(
      description: data['description'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'] ?? '',
      title: data['title'] ?? '',
      id: data['id'] ?? '',
      status: data['status']?? '',

    );
  }
}



