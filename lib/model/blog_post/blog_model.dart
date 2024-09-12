class BlogPost {
  final String imageUrl;
  final String title;
  final String category;
  final String readTime;
  final String content;

  BlogPost({
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.readTime,
    required this.content,
  });


  factory BlogPost.fromMap(Map<String, dynamic> data) {
    return BlogPost(
      imageUrl: data['imageUrl'] ?? '',
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      readTime: data['readTime'] ?? '',
      content: data['content'] ?? '',
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
  final String carbs;
  final String fat;
  final String imageUrl;
  final String name;
  final String protein;
  final String id;
  final String createdAt;


  AddMeal({
    required this.carbs,
    required this.fat,
    required this.imageUrl,
    required this.name,
    required this.protein,
    required this.id,
    required this.createdAt,

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



