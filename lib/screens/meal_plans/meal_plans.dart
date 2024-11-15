import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/stats_card.dart';
import '../../model/res/constant/app_icons.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/app_text_field.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/blog/blog_provider.dart';
import '../../provider/dropDOwn/dropdown.dart';

class MealPlanScreen extends StatelessWidget {
  MealPlanScreen({super.key});
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dropdownProvider = Provider.of<DropdownProvider>(context);
    final blogPostProvider = context.read<BlogPostProvider>();
    blogPostProvider.fetchDocumentCounts();

    return Scaffold(
      appBar: const CustomAppbar(text: 'Meal Plan Overview'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Provider.of<MenuAppController>(context,
                                listen: false)
                                .addBackPage(5);
                            
                            Provider.of<MenuAppController>(context,
                                listen: false)
                                .changeScreen(10);

                            // Get.toNamed(RoutesName.addMealPlan);
                          },
                          child: Row(
                            children: [
                              Container(
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
                                width: 15,
                              ),
                              const AppTextWidget(text: 'Create New Meal Plan'),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Container(
                          width: 200,
                          height: 30,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                              child:
                                  AppTextWidget(text: 'Meal Plan Management')),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Row(
              children: [
                Consumer<BlogPostProvider>(
                  builder: (context, blogPostProvider, child) {
                    return Row(
                      children: [
                        MealCard(
                          iconPath: AppIcons.totalUsers,
                          iconBackgroundColor: secondaryColor,
                          title: 'Total Meal Plans',
                          count: blogPostProvider.totalDocuments.toString(),
                          increaseColor: Colors.green,
                        ),
                        MealCard(
                          iconPath: AppIcons.activeUser,
                          iconBackgroundColor: primaryColor,
                          title: 'Recommended Meal Plans',
                          count: blogPostProvider.recommendedDocuments.toString(),
                          increaseColor: Colors.red,
                        ),
                      ],
                    );
                  },
                ),
                // MealCard(
                //   iconPath: AppIcons.time,
                //   iconBackgroundColor: secondaryColor,
                //   title: 'Most Popular Plan',
                //   count: 'Mother Essences',
                //   increaseColor: Colors.green,
                // ),
                // MealCard(
                //   iconPath: AppIcons.feedback,
                //   iconBackgroundColor: primaryColor,
                //   title: 'Avg rating',
                //   count: '4.5/5',
                //   increaseColor: Colors.green,
                // ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 40.w,
                  // height: 60.h,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const AppTextWidget(
                          text: 'Meal Management Plan',
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                buildHeaderButton('Meal Plan Name'),
                                SizedBox(
                                  width: 3.w,
                                ),
                                buildHeaderButton('Edit'),
                                SizedBox(
                                  width: 8.5.w,
                                ),
                                buildHeaderButton('Delete'),
                              ],
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 50.h,
                              width: 100.w,
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('mealCategory')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Center(child: Text('Error: ${snapshot.error}'));
                                    }
                                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                      return Center(child: Text('No Meal Category found'));
                                    }
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data?.docs.length,
                                        itemBuilder: (context, index) {
                                          var category =
                                          snapshot.data?.docs[index].data()
                                                  as Map<String, dynamic>;
                                          return buildListItem(
                                            category['mealCategory']
                                                .toString()
                                                .toUpperCase(),
                                            () {
                                              log('categoryId of meal category is ${category['Id']}');
                                              buildShowModalBottomSheet(
                                                context,
                                                blogPostProvider,
                                                category['Id'],
                                              );
                                            },
                                            () {
                                              blogPostProvider
                                                  .deleteMealCategory(
                                                      context, category['Id']);
                                            },
                                          );
                                        });
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  // height: 60.h,
                  width: 35.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(
                        text: 'User Engagement',
                        fontWeight: FontWeight.w400,
                        fontSize: 28,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          buildContainer('Total User Enrolled:', '500'),
                          SizedBox(
                            width: 4.w,
                          ),
                          buildContainer('Avg Completion Rate:', '80%'),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 23.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 6),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: AppTextWidget(
                              text: 'Most Active Users',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: AppTextWidget(
                          text: 'User A: 10 Plans ',
                          textAlign: TextAlign.start,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: AppTextWidget(
                          text: 'User B: 8 Plans ',
                          textAlign: TextAlign.start,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Container buildContainer(title, count) {
    return Container(
      padding: EdgeInsets.only(top: 14, left: 14, right: 18, bottom: 20),
      decoration: BoxDecoration(
        color: Color(0xffFBF0F3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: 1.h),
          AppTextWidget(
            text: title,
            fontSize: 10,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 1.h),
          AppTextWidget(
            text: count,
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(
    BuildContext context,
    BlogPostProvider blogPostProvider,
    id,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
          child: Column(
            children: [
              AppTextField(
                  hintText: 'Meal Category', controller: _categoryController),
              SizedBox(
                height: 4.h,
              ),
              ButtonWidget(
                text: 'Update',
                onClicked: () {
                  blogPostProvider.updateMealCategory(
                      context, id, _categoryController.text);
                },
                width: 100,
                height: 50,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        );
      },
    );
  }


  Widget buildListItem(
    String title,
    editOnTap,
    deleteOnTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AppTextWidget(
                text: title,
                fontSize: 14,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          SizedBox(
            width: 1.5.w,
          ),
          Expanded(
            child: InkWell(
              onTap: editOnTap,
              child: AppTextWidget(
                text: 'Edit',
                fontSize: 14,
                textAlign: TextAlign.start,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: deleteOnTap,
              child: AppTextWidget(
                text: 'Delete',
                fontSize: 14,
                textAlign: TextAlign.start,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: AppTextWidget(text: text, color: Colors.white, fontSize: 16),
    );
  }
}
