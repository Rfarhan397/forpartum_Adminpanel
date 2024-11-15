import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:html' as html;
import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/blog_post/blog_model.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/custom_dropDown.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/app_text_field.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/blog/blog_provider.dart';
import '../../provider/chip/chip_provider.dart';
import '../../provider/cloudinary/cloudinary_provider.dart';
import '../../provider/dropDOwn/dropdown.dart';
import '../../provider/stream/streamProvider.dart';

class LearningCenterScreen extends StatefulWidget {
  const LearningCenterScreen({super.key});

  @override
  State<LearningCenterScreen> createState() => _LearningCenterScreenState();
}

class _LearningCenterScreenState extends State<LearningCenterScreen> {
  Uint8List? _imageData;
  // Store image data
  TextEditingController _titleController = TextEditingController();

  TextEditingController _contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final chipProvider = Provider.of<ChipProvider>(context);
    final blogPostProvider = Provider.of<BlogPostProvider>(context);

    return Scaffold(
      appBar: CustomAppbar(text: 'Learning Center'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {

                  Provider.of<MenuAppController>(context, listen: false)
                      .addBackPage(26);
                  Provider.of<MenuAppController>(context, listen: false)
                      .changeScreen(27);
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
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    AppTextWidgetFira(
                      text: 'Add Learning Category',
                      fontSize: 14,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              SizedBox(height: 2.h,),
              Consumer<StreamDataProvider>(
                  builder: (context, productProvider, child) {
                    return StreamBuilder<List<AddLearningCategory>>(
                        stream: productProvider.getLearningCategories(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No learning Category found'));
                          }
                          List<AddLearningCategory> addLearningCategory = snapshot.data!;
                          addLearningCategory.sort((a, b) => a.createdAt.compareTo(b.createdAt)); // Sort by datetime

                          log("Length of learning Categories are :: ${snapshot.data!.length}");
                          return SizedBox(
                            height: 4.h,
                            width: 80.w,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: addLearningCategory.length,
                                itemBuilder: (context, index) {
                                  AddLearningCategory model = addLearningCategory[index];
                                  final isSelected = chipProvider.selectedCategory.toString() == addLearningCategory[index].category;
                                  final isHovered = chipProvider.hoveredCategory == addLearningCategory[index].category;
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,

                                    onTap: () {
                                      chipProvider.selectCategory(addLearningCategory[index].category);
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
                                            text: model.category,
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
              SizedBox(height: 2.h,),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: SizedBox(
                        width: 50.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    
                            const AppTextWidget(
                              text: 'Title',
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
                                    hintText: 'Postpartum Nutrition',
                                    radius: 5,
                                    controller: _titleController,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                    
                                // Consumer<DropdownProvider>(
                                //   builder: (context, dropdownProvider, child) {
                                //     log('blogPost categories are::${blogPostProvider.categories}');
                                //     log('blogPost category ids are::${blogPostProvider.categoriesIds}');
                                //     return
                                //       CustomDropdownWidget(
                                //         index: 1,
                                //         items: blogPostProvider.categories,
                                //         dropdownType: 'Category',
                                //       );
                                //   },
                                // ),
                              ],
                            ),
                            SizedBox(height: 3.h),
                            GestureDetector(
                              onTap: () async{
                                _pickAndUploadImage(context);
                              },
                              child: Container(
                                height: 5.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xffF7FAFC),
                                  border: Border.all(
                                    color: Color(0xffD1DBE8),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AppTextWidget(text: 'Upload Image',textAlign: TextAlign.start,color: Color(0xff4F7396),),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h,),
                            Consumer<CloudinaryProvider>(
                              builder: (context, provider, child) {
                                return provider.imageData != null
                                    ? Container(
                                  height: 20.h,
                                  width: 20.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Image.memory(
                                    provider.imageData!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : Container(
                                  height: 20.h,
                                  width: 20.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    //border: Border.all(color: Colors.black),
                                  ),
                                  child: Center(
                                    child: AppTextWidget(text:
                                    'No image selected',
                                        color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 5.h),
                    
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(padding: EdgeInsets.all(12)
                    ,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextWidget(text: 'Add Description here:',fontSize: 18,fontWeight: FontWeight.w500,),
                          SizedBox(height: 1.h,),
                          Container(
                            height: 50.h,
                            width: 45.w,
                            decoration: BoxDecoration(
                              //color: Colors.blueGrey[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),
                            child:  Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                maxLines: null,
                                expands: true,
                                controller: _contentController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ButtonWidget(
                                onClicked: () {
                                  ActionProvider().setLoading(true);
                                  _uploadLearningArticle(context);
                                },
                                text:('Upload'),
                                height: 5.h,
                                width: 10.w,
                                textColor: Colors.white,
                                radius: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // Accept only images

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);

      reader.onLoadEnd.listen((e) async {
        final bytes = reader.result as Uint8List;
        _imageData = bytes;

        // Set image data using Provider to display in the container
        final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
        cloudinaryProvider.setImageData(bytes);

        AppUtils().showToast(text: 'Image uploaded successfully');
      });
    });

    uploadInput.click(); // Trigger the file picker dialog
  }

  Future<void> _uploadLearningArticle(BuildContext context) async {
    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
    final dropdownProvider = Provider.of<DropdownProviderN>(context, listen: false);
    final chipProvider = Provider.of<ChipProvider>(context,listen: false);
    log('title:${_titleController.text.toString()}');
    log('content:${_contentController.text.toString()}');
    log('image:$_imageData');
    log('dropdown:${dropdownProvider.selectedCategory}');
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        chipProvider.selectedCategory.isEmpty ||
        cloudinaryProvider.imageData == null) {
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Please fill all fields and upload an image',);
      return;
    }

    try {
      await cloudinaryProvider.uploadImage(cloudinaryProvider.imageData!);
      var id = FirebaseFirestore.instance.collection('learningCenter').doc().id.toString();
      var categoryId = FirebaseFirestore.instance.collection('learningCategories').doc().id.toString();
      if (cloudinaryProvider.imageUrl.isNotEmpty) {
        //  Save the blog data to Firebase
        // Example Firebase code:
        await FirebaseFirestore.instance.collection('learningCenter').doc(id).set({
          'title': _titleController.text,
          'content': _contentController.text,
          'category': chipProvider.selectedCategory,
          'categoryId': categoryId,
          'imageUrl': cloudinaryProvider.imageUrl.toString(),
          'readTime': '5 mints'.toString(),
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'id': id.toString(),

        });
        ActionProvider.stopLoading();
        _titleController.clear();
        _contentController.clear();
        cloudinaryProvider.clearImage();

        AppUtils().showToast(text: 'uploaded successfully');
      } else {
        ActionProvider.stopLoading();
        AppUtils().showToast(text: 'Image upload failed',);
      }
    } catch (e) {
      log('Error uploading article: $e');
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Failed to upload article', );
    }
  }
}
