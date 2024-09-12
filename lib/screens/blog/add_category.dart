import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/blog_post/blog_model.dart';
import 'package:forpartum_adminpanel/provider/stream/streamProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../constant.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/app_text_field.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/blog/blog_provider.dart';
import '../../provider/chip/chip_provider.dart';

class AddCategory extends StatelessWidget {
  AddCategory({super.key});
  TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final blogPostProvider = Provider.of<BlogPostProvider>(context);
    final chipProvider = Provider.of<ChipProvider>(context);

    return Scaffold(
      appBar: const CustomAppbar(text: 'Dashboard'),
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
                      text: 'Category title',
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
                            hintText: 'Category',
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
                   Consumer<BlogPostProvider>(
                       builder: (context,provider, child){
                         return  Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 70.0),
                           child: Align(
                             alignment: Alignment.centerRight,
                             child: ButtonWidget(
                               onClicked: () async{
                                 ActionProvider().setLoading(true);
                                 if(provider.isUpdate){
                                    provider.updateCategory(context, provider.id, _categoryController.text.toString());
                                 }else{
                                   _uploadCategory(context);
                                 }

                               },
                               text: (provider.isUpdate ? "Update"  :  'Upload'),
                               height: 5.h,
                               width: 10.w,
                               textColor: Colors.white,
                               radius: 25,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                         );
                       }
                   ),
                    SizedBox(height: 10.h),
                    AppTextWidget(
                      text: 'Available Categories :',
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
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: blogPostProvider.categories.map((category) {
                    //     return Table(
                    //         border:
                    //             TableBorder.all(color: Colors.black, width: 2),
                    //         children: [
                    //           TableRow(children: [
                    //             Container(
                    //               padding: const EdgeInsets.all(10),
                    //               child: Center(
                    //                 child: AppTextWidget(
                    //                   text: category,
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
                    //                     // buildShowModalBottomSheet(
                    //                     //     context, blogPostProvider,);
                    //                     _categoryController.text = blogPostProvider.categories[1];
                    //                   },
                    //                   child: const Center(
                    //                       child: AppTextWidget(
                    //                     text: "Update",
                    //                   )),
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
                    //                     text: "Delete ",
                    //                   )),
                    //                 )),
                    //           ])
                    //         ]);
                    //   }).toList(),
                    // ),
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
                              return Center(child: Text('No category found'));
                            }

                            List<BlogCategory> blogCategory = snapshot.data!;
                            log("Length:: ${snapshot.data!.length}");
                            return ListView.builder(
                              itemCount: blogCategory.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                BlogCategory model = blogCategory[index];
                                return Table(
                                  border: TableBorder.all(color: Colors.black, width: 2),
                                  children: [
                                    TableRow(children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Center(
                                          child: AppTextWidget(
                                            text: model.category,
                                            textAlign: TextAlign.start,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: InkWell(
                                          onTap: () {
                                            // Logic for updating category
                                            _categoryController.text = model.category;
                                            blogPostProvider.setUpdate(true, model.id);
                                          },
                                          child: const Center(
                                            child: AppTextWidget(text: "Update"),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: InkWell(
                                          onTap: () {
                                            blogPostProvider.deleteCategory(context, model.id);
                                          },
                                          child: const Center(
                                            child: AppTextWidget(text: "Delete"),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<dynamic> buildShowModalBottomSheet(BuildContext context, BlogPostProvider blogPostProvider,) {
  //   return showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
  //         child: Column(
  //           children: [
  //             AppTextField(hintText: 'Category', controller: _categoryController),
  //             SizedBox(height: 4.h,),
  //             ButtonWidget(
  //               text: 'Update',
  //               onClicked: () {
  //                 blogPostProvider.updateCategory(context,);
  //               },
  //               width: 100,
  //               height: 50,
  //               fontWeight: FontWeight.normal,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }


  Future<void> _uploadCategory(BuildContext context) async {
    log('category:${_categoryController.text.toString()}');
    var id = FirebaseFirestore.instance
        .collection('blogsCategory')
        .doc()
        .id
        .toString();

    if (_categoryController.text.isEmpty == null) {
      ActionProvider.stopLoading();
      AppUtils().showToast(
        text: 'Please enter category name',
      );
      return;
    }

    try {
      if (_categoryController.text.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('blogsCategory')
            .doc(id)
            .set({
          'category': _categoryController.text,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'id': id.toString(),
        });
        ActionProvider.stopLoading();
        AppUtils().showToast(text: 'category uploaded successfully');
      } else {
        ActionProvider.stopLoading();
        AppUtils().showToast(
          text: 'Image upload failed',
        );
      }
    } catch (e) {
      log('Error uploading blog: $e');
      ActionProvider.stopLoading();
      AppUtils().showToast(
        text: 'Failed to upload blog',
      );
    }
  }
}
