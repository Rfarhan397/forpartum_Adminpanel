import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:forpartum_adminpanel/controller/menu_App_Controller.dart';
import 'package:forpartum_adminpanel/model/res/routes/routes_name.dart';
import 'package:forpartum_adminpanel/provider/action/action_provider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../constant.dart';
import '../../../provider/dropDOwn/dropdown.dart';
import '../../../provider/stream/streamProvider.dart';
import '../../blog_post/blog_model.dart';
import '../widgets/app_text.dart.dart';

class BlogPostCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final String readTime;
  final String content;
  final String id;
  final BlogPost arguments;

  const BlogPostCard({
    super.key,
    required this.imageUrl,
    required this.id,
    required this.title,
    required this.category,
    required this.readTime,
    required this.content,
    required this.arguments,
  });

  quill.QuillController getQuillController(String contentJson,) {
    try {
      final List<dynamic> decodedJson = jsonDecode(contentJson);
      final quill.Delta delta = quill.Delta.fromJson(decodedJson);
      return quill.QuillController(
        document: quill.Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      // Handle errors during decoding
      return quill.QuillController.basic();
    }
  }
  void _showDeleteDialog(BuildContext context, id, BlogPost arguments) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Blog!'),
          content: Text('Are you sure you want to edit or delete "$title"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<MenuAppController>(context, listen: false).addBackPage(4);
                Provider.of<MenuAppController>(context, listen: false).changeScreenWithParam(31,
                    arguments: arguments
                );
                Navigator.of(context).pop();
              },
              child: const Text('Edit', style: TextStyle(color: primaryColor)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ActionProvider>(context, listen: false).deleteItem('blogs', id);
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post deleted successfully')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: primaryColor)),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context,) {
    final quill.QuillController quillController = getQuillController(content);

    return Card(
      elevation: 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding: EdgeInsets.only(right: 2.5.w),
                child: InkWell(
                    onTap: () {
                      log('argument $arguments');
                      _showDeleteDialog(context,id,arguments);
                    },
                    child: const Icon(Icons.more_vert,color: primaryColor,))),
          ),
          Container(
            width: 15.w,
            height: 15.h,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget(
                  text: category,
                  color: primaryColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(width: 4.0),
                AppTextWidget(
                  text: readTime,
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: AppTextWidget(text: title,maxLines: 2,textAlign: TextAlign.start,fontSize: 18,fontWeight: FontWeight.w400,)
            ),
          ),
        ],
      ),
    );
  }
}

class BlogPostGrid extends StatelessWidget {
  final List<Map<String, String>> posts;

  BlogPostGrid({required this.posts});

  @override
  Widget build(BuildContext context) {
    final dropP = Provider.of<DropdownProviderN>(context);
   return  Container(
     height: 80.h,
     child: Consumer<StreamDataProvider>(
        builder: (context, provider, child) {
          return StreamBuilder<List<BlogPost>>(
            stream: dropP.selectedCategoryId.isNotEmpty ?  provider.getBlogFilter(categoryId: dropP.selectedCategoryId) :   provider.getBlog(),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No blog found'));
              }

              List<BlogPost> blogPost = snapshot.data!;
              log("Length of blog is:: ${snapshot.data!.length}");
                  return GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 1.0,
                      childAspectRatio: 3 / 2.5,
                    ),
                    itemCount: blogPost.length,
                    itemBuilder: (ctx, index) {
                      BlogPost post = blogPost[index];
                      return BlogPostCard(
                        imageUrl: post.imageUrl ?? "",
                        title: post.title ?? "",
                        category: post.category   ?? "",
                        readTime: formatTimestamp(post.createdAt) ?? "",
                        content: post.content ?? "",
                        id: post.id ?? "",
                        arguments: post
                      );
                    },

                  );
            },
          );
        },
      ),
   );


  }
  String formatTimestamp(String timestamp) {
    // Convert the string timestamp to a DateTime object (assuming it's in milliseconds)
    DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));

    // Get the current time
    DateTime now = DateTime.now();

    // Calculate the difference
    Duration difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      // Less than 1 minute
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      // Less than 1 hour
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      // Less than 1 day
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      // Less than 30 days
      return '${difference.inDays} days ago';
    } else {
      // More than 30 days
      return '${createdAt.month}/${createdAt.day}/${createdAt.year}';
    }
  }

}