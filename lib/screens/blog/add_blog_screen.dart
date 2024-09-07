import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/custom_dropDown.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/app_text_field.dart';
import '../../constant.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/blog/blog_provider.dart';
import '../../provider/cloudinary/cloudinary_provider.dart';
import '../../provider/dropDOwn/dropdown.dart';

class AddBlogScreen extends StatelessWidget {
  AddBlogScreen({super.key});
  Uint8List? _imageData; // Store image data
 TextEditingController _titleController = TextEditingController();
 TextEditingController _contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final blogPostProvider = Provider.of<BlogPostProvider>(context);

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
                      text: 'Article title',
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
                        Consumer<DropdownProviderN>(
                          builder: (context, dropdownProvider, child) {
                            return CustomDropdownWidget(
                              index: 0,
                              items: blogPostProvider.categories,
                              dropdownType: 'Category',
                            );
                          },
                        ),
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
                            _uploadBlog(context);
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
            ),
          ],
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

  Future<void> _uploadBlog(BuildContext context) async {
    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
    final dropdownProvider = Provider.of<DropdownProviderN>(context, listen: false);
    log('title:${_titleController.text.toString()}');
    log('content:${_contentController.text.toString()}');
    log('image:$_imageData');
    log('dropdown:${dropdownProvider.selectedCategory}');
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        dropdownProvider.selectedCategory.isEmpty ||
        cloudinaryProvider.imageData == null) {
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Please fill all fields and upload an image',);
      return;
    }

    try {
      await cloudinaryProvider.uploadImage(cloudinaryProvider.imageData!);
      var id = FirebaseFirestore.instance.collection('blogs').doc().id.toString();
      if (cloudinaryProvider.imageUrl.isNotEmpty) {
      //  Save the blog data to Firebase
       // Example Firebase code:
        await FirebaseFirestore.instance.collection('blogs').doc(id).set({
          'title': _titleController.text,
          'content': _contentController.text,
          'category': dropdownProvider.selectedCategory,
          'imageUrl': cloudinaryProvider.imageUrl.toString(),
          'readTime': '5 mints'.toString(),
          'createdAt': Timestamp.now(),
          'Id': id.toString(),

        });
        ActionProvider.stopLoading();
        AppUtils().showToast(text: 'Blog uploaded successfully');
      } else {
        ActionProvider.stopLoading();
        AppUtils().showToast(text: 'Image upload failed',);
      }
    } catch (e) {
      log('Error uploading blog: $e');
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Failed to upload blog', );
    }
  }
// Future<void> _pickAndUploadImage(BuildContext context) async {
  //   // Create an input element and simulate a file picker
  //   final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  //   uploadInput.accept = 'image/*'; // Accept only images
  //
  //   uploadInput.onChange.listen((e) async {
  //     final files = uploadInput.files;
  //     if (files!.isEmpty) return;
  //
  //     final reader = html.FileReader();
  //     reader.readAsArrayBuffer(files[0]);
  //     // reader.onLoadEnd.listen((e) async {
  //     //   final bytes = reader.result as Uint8List;
  //     //
  //     //   // Use Provider to upload the image
  //     //   final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
  //     //   await cloudinaryProvider.uploadImage(bytes);
  //     //   AppUtils().showToast(text: 'Image uploaded successfully : ${cloudinaryProvider.imageUrl}');
  //     //
  //     // });
  //   });
  //
  //   uploadInput.click(); // Trigger the file picker dialog
  // }

}
