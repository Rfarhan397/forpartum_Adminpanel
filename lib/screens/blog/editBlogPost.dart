import 'dart:developer';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart' as quill;
import 'package:forpartum_adminpanel/controller/menu_App_Controller.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:html' as html;
import 'package:flutter_quill/flutter_quill.dart' as quill;
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

class EditBlogPost extends StatefulWidget {
  EditBlogPost({super.key});

  @override
  State<EditBlogPost> createState() => _EditBlogPostState();
}

class _EditBlogPostState extends State<EditBlogPost> {
  Uint8List? _imageData; // Store image data
  TextEditingController _titleController = TextEditingController();
  late quill.QuillController _quillController = quill.QuillController.basic();

  @override
  void initState() {
    super.initState();
    final blogPostProvider = Provider.of<BlogPostProvider>(context, listen: false);
    blogPostProvider.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final blogPostProvider = Provider.of<BlogPostProvider>(context);
    final menuApp = Provider.of<MenuAppController>(context);
    final dropP = Provider.of<DropdownProviderN>(context);

    // final documentContent  = Document.fromJson(jsonDecode(menuApp.arguments!.content));
    final List<dynamic> decodedJson = jsonDecode(menuApp.arguments!.content);
    final quill.Delta delta = quill.Delta.fromJson(decodedJson);

    _quillController = quill.QuillController(
      document: quill.Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
    );

    if(!menuApp.isUpdate){
      dropP.setSelectedCategory(menuApp.arguments!.category,menuApp.arguments!.id);
      menuApp.toggleUpdate(true);
    }


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
                            hintText: _titleController.text = menuApp.arguments!.title,
                            radius: 5,
                            controller: _titleController,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Consumer<DropdownProvider>(
                          builder: (context, dropdownProvider, child) {
                            log('blogPost categories are::${blogPostProvider.categories}');
                            log('blogPost category ids are::${blogPostProvider.categoriesIds}');
                            return CustomDropdownWidget(
                              index: 1,
                              items: blogPostProvider.categories,
                              dropdownType: "Category",
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    GestureDetector(
                      onTap: () async {
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
                          child: AppTextWidget(
                            text: 'Upload Image',
                            textAlign: TextAlign.start,
                            color: Color(0xff4F7396),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
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
                          ),
                          child:Image.network(menuApp.arguments!.imageUrl)
                        );
                      },
                    ),
                    SizedBox(height: 5.h),
                    QuillSimpleToolbar(
                      controller: _quillController,
                      configurations: const QuillSimpleToolbarConfigurations(

                        showUnderLineButton: false,
                        showClearFormat: false,
                        showDirection: false,
                        showFontFamily: false,
                        showSuperscript: false,
                        showSubscript: false,
                        showStrikeThrough: false,
                        showSmallButton: false,
                        showSearchButton: false,
                        showUndo: false,
                        showRedo: false,
                        showQuote: false,
                        showListNumbers: true,
                        showFontSize: false,
                        showColorButton: false,
                        showBackgroundColorButton: false,
                        showHeaderStyle: false,
                        showListCheck: false,
                        showCodeBlock: false,
                        showLink: true,
                        showIndent: true,
                        showClipboardCut: false,
                        showClipboardCopy: false,
                        showClipboardPaste: false,

                      ),
                    ),
                    Container(
                      height: 50.h,
                      width: 45.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: quill.QuillEditor(
                          controller: _quillController,
                          scrollController: ScrollController(),
                          // scrollable: true,
                          focusNode: FocusNode(),
                          // autoFocus: false,
                          // readOnly: false,
                          // expands: true,
                          // padding: Ed/geInsets.zero,
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
                            _updateBlog(context);
                          },
                          text: 'Update',
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

  Future<void> _updateBlog(BuildContext context) async {
    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
    final dropdownProvider = Provider.of<DropdownProviderN>(context, listen: false);
    final mneuP = Provider.of<MenuAppController>(context, listen: false);

    // Convert Quill document to JSON
    String contentJson = jsonEncode(_quillController.document.toDelta().toJson());
    log('contentJson:$contentJson');


    try {

      var id = mneuP.arguments!.id;

      if(cloudinaryProvider.imageData !=null){
        await cloudinaryProvider.uploadImage(cloudinaryProvider.imageData!);
      }
      // Prepare the image URL (either new or existing)
      final imageUrl = cloudinaryProvider.imageUrl.isNotEmpty
          ? cloudinaryProvider.imageUrl
          : mneuP.arguments!.imageUrl.toString();
      // Initialize Firestore batch
      final batch = FirebaseFirestore.instance.batch();
      final blogDoc = FirebaseFirestore.instance.collection('blogs').doc(id);

      batch.update(blogDoc, {
        'title': _titleController.text,
        'content': contentJson,
        'categoryId': dropdownProvider.selectedCategoryId,
        'category': dropdownProvider.selectedCategory,
        'imageUrl': imageUrl,
      });

      // Commit the batch
      await batch.commit();
        ActionProvider.stopLoading();
        _titleController.clear();
        _quillController.clear();
        cloudinaryProvider.clearImage();
        AppUtils().showToast(text: 'Blog updated successfully');
    } catch (e) {
      log('Error uploading blog: $e');
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Failed to update blog');
    }
  }
}
