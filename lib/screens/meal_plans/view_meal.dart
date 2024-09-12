import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/blog_post/blog_model.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/pagination.dart';
import '../../model/res/constant/app_assets.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../provider/blog/blog_provider.dart';
import '../../provider/chip/chip_provider.dart';
import '../../provider/dropDOwn/dropdown.dart';
import '../../provider/navigation/navigationProvider.dart';
import '../../provider/stream/streamProvider.dart';

class ViewMealScreen extends StatefulWidget {
  ViewMealScreen({super.key});

  @override
  State<ViewMealScreen> createState() => _ViewMealScreenState();
}

class _ViewMealScreenState extends State<ViewMealScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data from Firebase when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final blogProvider =
          Provider.of<BlogPostProvider>(context, listen: false);
      blogProvider.fetchMealCategories();
    });
  }

  final int itemsPerPage = 8;
  // Items per page
  final List<String> meals =
      List.generate(18, (index) => 'Roasted Red Pepper Soup $index');
  // Example meal data
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityLogProvider>(context);
    final dropdownProvider = Provider.of<DropdownProvider>(context);
    final chipProvider = Provider.of<ChipProvider>(context);
    final blogPostProvider = Provider.of<BlogPostProvider>(context);

    int totalPages =
        (meals.length / itemsPerPage).ceil(); // Calculate total pages
    int currentPage = provider.currentPage;

    // Get the items for the current page
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    List<String> currentMeals = meals.sublist(
        startIndex, endIndex > meals.length ? meals.length : endIndex);

    return Scaffold(
      appBar: CustomAppbar(text: 'All Meals-Mother Essence'),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Provider.of<MenuAppController>(context, listen: false)
                            .changeScreen(11);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    AppTextWidgetFira(
                      text: 'Add Meal',
                      fontSize: 14,
                      color: Colors.black,
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Provider.of<MenuAppController>(context, listen: false)
                            .changeScreen(24);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    AppTextWidgetFira(
                      text: 'Add Meal Category',
                      fontSize: 14,
                      color: Colors.black,
                    )
                  ],
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                alignment: Alignment.centerRight,
                child: DropdownButton<String>(
                  value: dropdownProvider.selectedValue,
                  items: <String>['Last 30 Days', 'Last 10 Days', 'Yesterday']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: AppTextWidget(text: value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      dropdownProvider.setSelectedValue(newValue);
                    }
                  },
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                ),
              ),
            ),
            Consumer<StreamDataProvider>(
                builder: (context, productProvider, child) {
              return StreamBuilder<List<AddMealCategory>>(
                  stream: productProvider.getMealPlanCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No Meal Category found'));
                    }
                    List<AddMealCategory> addMealCategory = snapshot.data!;
                    addMealCategory.sort((a, b) => a.createdAt.compareTo(b.createdAt)); // Sort by datetime

                    log("Length of addMeal Categories are :: ${snapshot.data!.length}");
                    return SizedBox(
                      height: 4.h,
                      width: 80.w,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: addMealCategory.length,
                          itemBuilder: (context, index) {
                            AddMealCategory model = addMealCategory[index];
                            final isSelected = chipProvider.selectedCategory.toString() == addMealCategory[index].mealCategory;
                            final isHovered = chipProvider.hoveredCategory == addMealCategory[index].mealCategory;
                            return InkWell(
                              splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            chipProvider.selectCategory(addMealCategory[index].mealCategory);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                color:
                                isSelected
                                    ? primaryColor
                                    : isHovered
                                    ? primaryColor
                                    :
                                secondaryColor,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Center(
                                child: AppTextWidget(
                                  text: model.mealCategory,
                                  color:
                                  isSelected
                                      ? Colors.white
                                      : isHovered
                                      ? Colors.white
                                      :
                                  Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  });
            }),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: blogPostProvider.mealCategories.map((category) {
            //     final isSelected = chipProvider.selectedCategory == category;
            //     final isHovered = chipProvider.hoveredCategory == category;
            //     return Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //       child: MouseRegion(
            //         onEnter: (_) {
            //           chipProvider.setHoveredCategory(category);
            //         },
            //         onExit: (_) {
            //           chipProvider.clearHoveredCategory();
            //         },
            //         child: GestureDetector(
            //           onTap: () {
            //             chipProvider.selectCategory(category);
            //           },
            //           child: Container(
            //             padding: EdgeInsets.symmetric(
            //                 vertical: 5.0, horizontal: 10.0),
            //             decoration: BoxDecoration(
            //               color: isSelected
            //                   ? primaryColor
            //                   : isHovered
            //                       ? primaryColor
            //                       : secondaryColor,
            //               borderRadius: BorderRadius.circular(6.0),
            //             ),
            //             child: AppTextWidget(
            //               text: category,
            //               color: isSelected
            //                   ? Colors.white
            //                   : isHovered
            //                       ? Colors.white
            //                       : Colors.black,
            //               fontWeight: FontWeight.w700,
            //             ),
            //           ),
            //         ),
            //       ),
            //     );
            //   }).toList(),
            // ),
            SizedBox(
              height: 20,
            ),
            Consumer<StreamDataProvider>(
                builder: (context, productProvider, child) {
              return StreamBuilder<List<AddMeal>>(
                  stream: productProvider.getMealPlan(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No Meal found'));
                    }
                    List<AddMeal> addMeal = snapshot.data!;
                    log("Length of addMeals is:: ${snapshot.data!.length}");
                    return Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                          itemCount: addMeal.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 2.0,
                            childAspectRatio: 2 / 2,
                          ),
                          itemBuilder: (context, index) {
                            AddMeal model = addMeal[index];

                            return Container(
                              height: 4.h,
                              width: 20.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        model.imageUrl,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  AppTextWidgetFira(
                                    text: model.name,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    textAlign: TextAlign.start,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  });
            }),
            // StreamBuilder(
            //   stream: FirebaseFirestore.instance
            //       .collection('addMeal')
            //       .snapshots(),
            //   builder: (context, snapshots) {
            //     return Expanded(
            //       child: GridView.builder(
            //           itemCount: snapshots.data?.docs.length,
            //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //             crossAxisCount: 4,
            //             crossAxisSpacing: 10.0,
            //             mainAxisSpacing: 2.0,
            //             childAspectRatio: 2 / 2,
            //           ),
            //           itemBuilder: (context, index) {
            //             var blogs = snapshots.data?.docs[index].data()
            //                 as Map<String, dynamic>;
            //
            //             return Container(
            //               height: 4.h,
            //               width: 20.w,
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   SizedBox(
            //                     height: 200,
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(12),
            //                       child: Image.network(
            //                         blogs['imageUrl'],
            //                         fit: BoxFit.contain,
            //                       ),
            //                     ),
            //                   ),
            //                   SizedBox(height: 10),
            //                   AppTextWidgetFira(
            //                     text: blogs['name'],
            //                     fontWeight: FontWeight.w600,
            //                     fontSize: 14,
            //                     textAlign: TextAlign.start,
            //                     color: Colors.black,
            //                   ),
            //                 ],
            //               ),
            //             );
            //           }),
            //     );
            //   },
            // );
            Container(
              margin: EdgeInsets.only(right: 40, bottom: 20),
              alignment: Alignment.centerRight,
              child: PaginationWidget(
                currentPage: currentPage,
                totalPages: totalPages,
                onPageChanged: (page) {
                  provider.goToPage(page);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
