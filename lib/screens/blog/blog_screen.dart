import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/blog_post/blog_model.dart';
import '../../model/res/components/blogPostCard.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/pagination.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../provider/blog/blog_provider.dart';
import '../../provider/chip/chip_provider.dart';
import '../../provider/dropDOwn/dropdown.dart';
import '../../provider/stream/streamProvider.dart';

class BlogScreen extends StatefulWidget {
   BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {


  @override
  Widget build(BuildContext context) {
    final dropdownProvider = Provider.of<DropdownProvider>(context);
    final chipProvider = Provider.of<ChipProvider>(context);
    final blogPostProvider = Provider.of<BlogPostProvider>(context);


    return Scaffold(
      appBar: CustomAppbar(text: 'Dashboard'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Provider.of<MenuAppController>(context,
                                  listen: false)
                                  .addBackPage(4);
                              Provider.of<MenuAppController>(context, listen: false)
                                  .changeScreen(13);                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: primaryColor,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.add,color: Colors.white,),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                AppTextWidgetFira(text: 'New Blog Post',fontSize: 14,color: Colors.black,)
                              ],
                            ),
                          ),
                          SizedBox(width: 3.w,),
                          InkWell(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {

                              Provider.of<MenuAppController>(context,
                                  listen: false)
                                  .addBackPage(4);
                              Provider.of<MenuAppController>(context, listen: false)
                                  .changeScreen(23);
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: primaryColor,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.add,color: Colors.white,),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                AppTextWidgetFira(text: 'Add Category',fontSize: 14,color: Colors.black,)
                              ],
                            ),
                          ),
                          SizedBox(width: 5,),
                        ],
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      //   child: Container(
                      //     alignment: Alignment.centerRight,
                      //     child: DropdownButton<String>(
                      //       value: dropdownProvider.selectedValue,
                      //       items: <String>['Last 30 Days', 'Last 10 Days', 'Yesterday'].map((String value) {
                      //         return DropdownMenuItem<String>(
                      //           value: value,
                      //           child: AppTextWidget(text: value),
                      //         );
                      //       }).toList(),
                      //       onChanged: (String? newValue) {
                      //         if (newValue != null) {
                      //           dropdownProvider.setSelectedValue(newValue);
                      //         }
                      //       },
                      //       underline: SizedBox(),
                      //       icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                      //     ),
                      //   ),
                      // ),

                    ],
                  ),
                  SizedBox(height: 2.h,),

                  Consumer<StreamDataProvider>(
                    builder: (context, productProvider, child) {
                      return StreamBuilder<List<BlogCategory>>(
                        stream: productProvider.getBlogCategory(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No Blog Category found'));
                          }

                          // Get dynamic categories
                          List<BlogCategory> blogCategory = snapshot.data!;
                          // Sort dynamic categories
                          blogCategory.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                          // Prepend a static "All" category
                          blogCategory.insert(
                            0,
                            BlogCategory(
                              id: "all",
                              category: "All",
                              createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
                            ),
                          );

                          log("Length of Blog Categories are :: ${blogCategory.length}");

                          return SizedBox(
                            height: 4.h,
                            width: 80.w,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: blogCategory.length,
                              itemBuilder: (context, index) {
                                BlogCategory model = blogCategory[index];
                                final isSelected =
                                    chipProvider.selectedCategory.toString() == model.category;
                                final isHovered =
                                    chipProvider.hoveredCategory == model.createdAt;

                                return InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    chipProvider.selectCategory(model.category);

                                    if (model.category.toLowerCase() == "all") {
                                      Provider.of<DropdownProviderN>(context, listen: false)
                                          .setSelectedCategory(model.category, "");
                                    } else {
                                      Provider.of<DropdownProviderN>(context, listen: false)
                                          .setSelectedCategory(model.category, model.id);
                                    }

                                    log("Category Id: ${model.id}");
                                    log('selected category is :: ${Provider.of<DropdownProviderN>(context, listen: false)
                                        .selectedCategory}');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                      padding:
                                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? primaryColor
                                            : isHovered
                                            ? primaryColor
                                            : secondaryColor,
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      child: Center(
                                        child: AppTextWidget(
                                          text: model.category,
                                          color: isSelected
                                              ? Colors.white
                                              : isHovered
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(height: 2.h,),


                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  //   child: SingleChildScrollView(
                  //     scrollDirection: Axis.horizontal,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: blogPostProvider.categories.map((category) {
                  //         final isSelected = chipProvider.selectedCategory == category;
                  //         final isHovered = chipProvider.hoveredCategory == category;
                  //
                  //         return Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //           child: MouseRegion(
                  //             onEnter: (_) {
                  //               chipProvider.setHoveredCategory(category);
                  //             },
                  //             onExit: (_) {
                  //               chipProvider.clearHoveredCategory();
                  //             },
                  //             child: GestureDetector(
                  //               onTap: () {
                  //                 chipProvider.selectCategory(category);
                  //                 blogPostProvider.filterPostsByCategory(category);  // Filter posts
                  //               },
                  //               child: Container(
                  //                 padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 14.0),
                  //                 decoration: BoxDecoration(
                  //                   color: isSelected ? primaryColor : isHovered ? primaryColor : secondaryColor,
                  //                   borderRadius: BorderRadius.circular(8.0),
                  //                 ),
                  //                 child: AppTextWidget(
                  //                   text: category,
                  //                   color: isSelected ? Colors.white : isHovered ? Colors.white : Colors.black,
                  //                   fontWeight: FontWeight.w400,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  //       }).toList(),
                  //     ),
                  //   ),
                  // ),
                  BlogPostGrid(posts: blogPostProvider.filteredPosts),
                  // Align(
                  //   alignment: Alignment.bottomRight,
                  //   child: Container(
                  //     margin: EdgeInsets.only(right: 40, bottom: 20),
                  //     alignment: Alignment.centerRight,
                  //     child: PaginationWidget(
                  //       currentPage: blogPostProvider.currentPage,
                  //       totalPages: blogPostProvider.totalPages,
                  //       onPageChanged: (page) {
                  //         blogPostProvider.goToPage(page);
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
