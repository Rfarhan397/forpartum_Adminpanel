import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/blog_post/blog_model.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/pagination.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/blog/blog_provider.dart';
import '../../provider/chip/chip_provider.dart';
import '../../provider/dropDOwn/dropdown.dart';
import '../../provider/navigation/navigationProvider.dart';
import '../../provider/stream/streamProvider.dart';

class ViewMealScreen extends StatefulWidget {
  const ViewMealScreen({super.key});

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
      appBar: const CustomAppbar(text: 'All Meals-Mother Essence'),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Provider.of<MenuAppController>(context, listen: false)
                        .addBackPage(10);
                    Provider.of<MenuAppController>(context, listen: false)
                        .changeScreen(11);
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
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const AppTextWidgetFira(
                        text: 'Add Meal',
                        fontSize: 14,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                // const SizedBox(
                //   width: 10,
                // ),
                // InkWell(
                //   hoverColor: Colors.transparent,
                //   splashColor: Colors.transparent,
                //   highlightColor: Colors.transparent,
                //   onTap: () {
                //     Provider.of<MenuAppController>(context, listen: false)
                //         .addBackPage(10);
                //     Provider.of<MenuAppController>(context, listen: false)
                //         .changeScreen(24);
                //   },
                //   child: Row(
                //     children: [
                //       Container(
                //         width: 30,
                //         height: 30,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(15),
                //           color: primaryColor,
                //         ),
                //         child: const Center(
                //           child: Icon(
                //             Icons.add,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //       const SizedBox(
                //         width: 5,
                //       ),
                //       const AppTextWidgetFira(
                //         text: 'Add Meal Category',
                //         fontSize: 14,
                //         color: Colors.black,
                //       )
                //     ],
                //   ),
                // ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4.h,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: Container(
            //     alignment: Alignment.centerRight,
            //     child: DropdownButton<String>(
            //       value: dropdownProvider.selectedValue,
            //       items: <String>['Last 30 Days', 'Last 10 Days', 'Yesterday']
            //           .map((String value) {
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
            Consumer<StreamDataProvider>(
                builder: (context, productProvider, child) {
              return StreamBuilder<List<AddMealCategory>>(
                  stream: productProvider.getMealPlanCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No Meal Category found'));
                    }
                    List<AddMealCategory> addMealCategory = snapshot.data!;
                    addMealCategory.sort((a, b) =>
                        a.createdAt.compareTo(b.createdAt)); // Sort by datetime
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: isSelected ? primaryColor : isHovered ? primaryColor : secondaryColor,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Center(
                                    child: AppTextWidget(
                                      text: model.mealCategory.toUpperCase(),
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
                          }),
                    );
                  });
            }),
             SizedBox(
              height: 3.h,
            ),
            Consumer2<StreamDataProvider,ChipProvider>(
                builder: (context, productProvider,chip, child) {
              return StreamBuilder<List<AddMeal>>(
                  stream: productProvider.getMealPlan(
                      chip.selectedCategory
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No meals found'));
                    }
                    List<AddMeal> addMeal = snapshot.data!;
                    log("Length of addMeals is:: ${snapshot.data!.length}");
                    return Expanded(
                      child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: addMeal.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    width: 100.w,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            model.imageUrl!,
                                            fit: BoxFit.cover,
                                            width: double.infinity, // Ensures the image fills the available space
                                            height: double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0.5.h, // Adjust as needed for icon placement
                                          right: 1.w, // Adjust as needed for icon placement
                                          child: InkWell(
                                              onTap: () {

                                                _showDeleteDialog(context,model.id,model,model.mealType);
                                              },
                                              child: const Icon(Icons.more_vert,color: primaryColor,))
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  AppTextWidgetFira(
                                    text: model.name!,
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
            // Container(
            //   margin: const EdgeInsets.only(right: 40, bottom: 20),
            //   alignment: Alignment.centerRight,
            //   child: PaginationWidget(
            //     currentPage: provider.currentPage,
            //     totalPages: totalPages,
            //     onPageChanged: (page) {
            //       provider.goToPage(page);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
  void _showDeleteDialog(BuildContext context,id,AddMeal model,mealType ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Meal!'),
          content: Text('Are you sure you want to edit or delete? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<MenuAppController>(context, listen: false).addBackPage(10);
                Provider.of<MenuAppController>(context, listen: false).changeScreenWithParamsModel(33,
                    arguments: model,
                  mealType: mealType
                );
                Navigator.of(context).pop();
              },
              child: const Text('Edit', style: TextStyle(color: primaryColor)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ActionProvider>(context, listen: false).deleteItem('addMeal', id);
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

}
