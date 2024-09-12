import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/blog_post/blog_model.dart';
import 'package:forpartum_adminpanel/provider/dropDOwn/dropdown.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constant.dart';
import '../../../provider/blog/blog_provider.dart';
import '../../../provider/stream/streamProvider.dart';
import '../../blog_post/blog_model.dart';
import '../../blog_post/blog_model.dart';
import '../widgets/app_text.dart.dart';
//   class BlogPostCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String category;
//   final String readTime;
//   //final Color color;
//
//   const BlogPostCard({super.key,
//   required this.imageUrl,
//   required this.title,
//   required this.category,
//   required this.readTime,
//     //required this.color,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0.0,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 15.w,
//             height: 15.h,
//             child: Image.asset(
//               imageUrl,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppTextWidget(
//                   text: category,
//                   color: primaryColor,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w400,
//                 ),
//                 SizedBox(width: 4.0),
//                 AppTextWidget(
//                   text: readTime,
//                   color: Colors.grey,
//                   fontSize: 10,
//                 ),
//
//               ],
//             ),
//           ),
//           Padding(
//             padding:  EdgeInsets.only(right: 4.w),
//             child: AppTextWidget(
//               text: title,
//               softWrap: true,
//               fontSize: 12,
//               textAlign: TextAlign.start,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class BlogPostCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final String readTime;
  final String content;

  const BlogPostCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.readTime,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                SizedBox(width: 4.0),
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
            child: AppTextWidgetContent(
              text: content,
              fontSize: 12,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
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
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No blog found'));
              }

              List<BlogPost> blogPost = snapshot.data!;
              log("Length of blog is:: ${snapshot.data!.length}");
                  return GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        readTime: post.readTime ?? "",
                        content: post.content ?? "",
                      );
                    },
                  );
            },
          );
        },
      ),
   );


  }
}
// class BlogPostGrid extends StatelessWidget {
//   final List<Map<String, String>> posts;
//
//   BlogPostGrid({required this.posts});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 80.h,
//       child: GridView.builder(
//         shrinkWrap: true,
//         padding: const EdgeInsets.all(8.0),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 4,
//           crossAxisSpacing: 1.0,
//           mainAxisSpacing: 1.0,
//           childAspectRatio: 3 / 2.5,
//         ),
//         itemCount: posts.length,
//         itemBuilder: (ctx, index) {
//           return BlogPostCard(
//             imageUrl: posts[index]['imageUrl']!,
//             title: posts[index]['title']!,
//             category: posts[index]['category']!,
//             readTime: posts[index]['readTime']!,
//             //color: null,
//           );
//         },
//       ),
//     );
//   }
// }
