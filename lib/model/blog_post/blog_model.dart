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


  BlogCategory({
    required this.category,

  });


  factory BlogCategory.fromMap(Map<String, dynamic> data) {
    return BlogCategory(
      category: data['category'] ?? '',

    );
  }
}