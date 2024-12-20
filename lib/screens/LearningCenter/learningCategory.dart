import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../model/res/components/custom_appBar.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/app_text_field.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/blog/blog_provider.dart';

class LearningCategory extends StatelessWidget {
  LearningCategory({super.key});
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final blogPostProvider = Provider.of<BlogPostProvider>(context);

    return Scaffold(
      appBar: const CustomAppbar(text: 'Learning Category'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 1.0,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: SizedBox(
                width: 50.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppTextWidget(
                      text: 'Learning Category title',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 8.h,
                          width: 30.w,
                          child: AppTextFieldBlue(
                            hintText: 'Learning Category',
                            radius: 5,
                            controller: _categoryController,
                          ),
                        ),
                        SizedBox(width: 5.w),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(height: 5.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ButtonWidget(
                          onClicked: () {
                            ActionProvider().setLoading(true);
                            _uploadCategory(context);
                          },
                          text: ('Upload'),
                          height: 5.h,
                          width: 10.w,
                          textColor: Colors.white,
                          radius: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    AppTextWidget(
                      text: 'Available Learning Categories :',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    Table(
                      border: TableBorder.all(color: Colors.black, width: 2),
                      children: [
                        TableRow(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                child: const Center(
                                    child: AppTextWidget(
                                      text: "Category",
                                      fontWeight: FontWeight.bold,
                                    ))),
                            Container(
                                padding: const EdgeInsets.all(10),
                                child: const Center(
                                    child: AppTextWidget(
                                      text: "Update",
                                      fontWeight: FontWeight.bold,
                                    ))),
                            Container(
                                padding: const EdgeInsets.all(10),
                                child: const Center(
                                    child: AppTextWidget(
                                      text: "Delete ",
                                      fontWeight: FontWeight.bold,
                                    ))),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50.h,
                      width: 100.w,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('learningCategories')
                        .orderBy("createdAt", descending: false)
                            .snapshots(),

                        builder: (context, snapShots) {
                          if (snapShots.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapShots.hasError) {
                            return Center(child: Text('Error: ${snapShots.error}'));
                          }
                          if (!snapShots.hasData || snapShots.data!.docs.isEmpty) {
                            return Center(child: Text('No learning Category found'));
                          }
                          return ListView.builder(
                              itemCount: snapShots.data?.docs.length,
                              itemBuilder: (context, index) {
                                var category = snapShots.data?.docs[index]
                                    .data() as Map<String, dynamic>;
                                log('learning category id iss::${category['Id']}');

                                return Table(
                                  border: TableBorder.all(
                                      color: Colors.black, width: 2),
                                  children: [
                                    TableRow(children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Center(
                                            child: Center(
                                                child: AppTextWidget(
                                                  text: category['category']
                                                      .toString()
                                                      .toUpperCase(),
                                                ))),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: InkWell(
                                            onTap: () {
                                              buildShowModalBottomSheet(context, blogPostProvider,category['Id']);
                                            },
                                            child: const Center(
                                              child: AppTextWidget(
                                                text: 'UPDATE',
                                                textDecoration: TextDecoration.underline,
                                                underlinecolor: Colors.black,
                                              ),
                                            )),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.all(10),
                                          child: InkWell(
                                              onTap: () {
                                                blogPostProvider.deleteLearningCategory(context,category['Id']);
                                              },
                                              child: const Center(
                                                child: AppTextWidget(
                                                  text: 'Delete',
                                                  textDecoration: TextDecoration.underline,
                                                  underlinecolor: Colors.black,
                                                ),
                                              ))),
                                    ]),
                                  ],
                                );
                              });
                        },
                      ),
                    )

                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: blogPostProvider.mealCategories.map((mealCategory) {
                    //     return Table(
                    //         border:
                    //         TableBorder.all(color: Colors.black, width: 2),
                    //         children: [
                    //           TableRow(children: [
                    //             Container(
                    //               padding: const EdgeInsets.all(10),
                    //               child: Center(
                    //                 child: AppTextWidget(
                    //                   text: mealCategory,
                    //                   textAlign: TextAlign.start,
                    //                   color: Colors.black,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //               ),
                    //             ),
                    //             Container(
                    //                 padding: const EdgeInsets.all(10),
                    //                 child: InkWell(
                    //                   onTap: () {
                    //                     buildShowModalBottomSheet(context, blogPostProvider,);
                    //                   },
                    //                   child: const Center(
                    //                       child: AppTextWidget(
                    //                         text: "Update",
                    //                       )),
                    //                 )),
                    //             Container(
                    //                 padding: const EdgeInsets.all(10),
                    //                 child: InkWell(
                    //                   onTap: () {
                    //                     blogPostProvider
                    //                         .deleteCategory(context);
                    //                   },
                    //                   child: const Center(
                    //                       child: AppTextWidget(
                    //                         text: "Delete ",
                    //                       )),
                    //                 )),
                    //           ])
                    //         ]);
                    //   }).toList(),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(
      BuildContext context,
      BlogPostProvider blogPostProvider,
      categoryId
      ) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
          child: Column(
            children: [
              AppTextField(
                  hintText: 'Learning Category', controller: _categoryController),
              SizedBox(
                height: 4.h,
              ),
              ButtonWidget(
                text: 'Update',
                onClicked: () {
                  blogPostProvider.updateLearningCategory(
                    context,
                    categoryId,
                    _categoryController.text.toString(),
                  );
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

  Future<void> _uploadCategory(BuildContext context) async {
    log('learning category:${_categoryController.text.toString()}');
    var id = FirebaseFirestore.instance
        .collection('learningCategories')
        .doc()
        .id
        .toString();

    if (_categoryController.text.isEmpty == null) {
      ActionProvider.stopLoading();
      AppUtils().showToast(
        text: 'Please enter Category Name',
      );
      return;
    }

    try {
      if (_categoryController.text.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('learningCategories')
            .doc(id)
            .set({
          'category': _categoryController.text,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'Id': id.toString(),
        });
        ActionProvider.stopLoading();
        AppUtils().showToast(text: 'category uploaded successfully');
        _categoryController.clear();
      } else {
        ActionProvider.stopLoading();
        AppUtils().showToast(
          text: 'Image upload failed',
        );
      }
    } catch (e) {
      log('Error uploading Learning category: $e');
      ActionProvider.stopLoading();
      AppUtils().showToast(
        text: 'Failed to upload category',
      );
    }
  }
}
