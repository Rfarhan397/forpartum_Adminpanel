import 'dart:developer';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/app_button_widget.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/cloudinary/cloudinary_provider.dart';

class EditMealPlan extends StatelessWidget {
  EditMealPlan({super.key});
  Uint8List? _imageData; // Store image data
  Uint8List? _breakfastImageData;
  Uint8List? _lunchImageData;
  Uint8List? _snackImageData;
  Uint8List? _dinnerImageData;
  TextEditingController breakFastController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController recipeController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController recommendedBreakfastController =
  TextEditingController();
  TextEditingController descriptionBreakfastController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentP = Provider.of<CloudinaryProvider>(context);
    final menuApp = Provider.of<MenuAppController>(context);

    return Scaffold(
      appBar: CustomAppbar(text: 'Mother Essence Plan'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMealFields(context, () {
                        currentP.setCurrentType(menuApp.model!.mealType!);
                        _updateMeal(context);
                      },
                          menuApp.model!.mealType!,
                          breakFastController,
                          proteinController,
                          carbsController,
                          fatController,
                          recipeController,
                          ingredientsController,
                          recommendedBreakfastController,
                          descriptionBreakfastController),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildMealFields(
      BuildContext context,
      VoidCallback onPressed,
      String heading,
      TextEditingController mealController,
      TextEditingController proteinController,
      TextEditingController carbsController,
      TextEditingController fatController,
      TextEditingController recipeController,
      TextEditingController ingredientsController,
      TextEditingController recommendedController,
      TextEditingController descriptionController,
      ) {
    final menuApp = Provider.of<MenuAppController>(context);

    bool isRecommended = false; // Track recommendation state

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 30.w,
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextWidget(text: heading, fontWeight: FontWeight.w600),
                    SizedBox(height: 1.h),
                    TextField(
                      controller: mealController,
                      decoration: InputDecoration(
                        fillColor: Color(0xffF7FAFC),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD1DBE8)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD1DBE8)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: mealController.text = menuApp.model!.name!,
                        hintStyle:
                        TextStyle(fontSize: 16, color: Color(0xff4F7396)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 35.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildNutrientField(proteinController, 'Protein', proteinController.text = menuApp.model!.protein!),
                    buildNutrientField(carbsController, 'Carbs', carbsController.text = menuApp.model!.carbs!),
                    buildNutrientField(fatController, 'Fat', fatController.text = menuApp.model!.fat!),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            buildTextFieldColumn('Recipe:',recipeController.text = menuApp.model!.recipe!, recipeController),
            SizedBox(width: 5.w),
            buildTextFieldColumn("Ingredients:",ingredientsController.text = menuApp.model!.ingredients!, ingredientsController),
            SizedBox(width: 5.w),
            buildUploadImagedButton(context, heading),
            SizedBox(width: 0.5.w),
            buildImageDisplay(
              context,
              heading,
              menuApp.model!.imageUrl
            ), // Display corresponding image
          ],
        ),
        // Add the Recommend button here
        Row(
          children: [
            buildNutrientField(
                recommendedController,  'Recommended',recommendedController.text = menuApp.model!.recommended!,),
            SizedBox(
              width: 5.w,
            ),
            buildNutrientField(
                descriptionController,  'Description',descriptionController.text = menuApp.model!.description!,),
          ],
        ),
        ButtonWidget(
          fontWeight: FontWeight.w400,
          height: 5.h,
          width: 120,
          alignment: Alignment.centerRight,
          onClicked: onPressed,
          text: 'Update',
          radius: 20,
        ),
      ],
    );
  }

  Widget buildNutrientField(
      TextEditingController controller, String heading, String hintText) {
    return SizedBox(
      width: 10.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget(text: heading, fontWeight: FontWeight.w600),
          SizedBox(height: 1.h),
          IntrinsicHeight(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                fillColor: Color(0xffF7FAFC),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffD1DBE8)),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 16, color: Color(0xff4F7396)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFieldColumn(
      String heading,hintText, TextEditingController controller) {
    return Container(
      // height: 30.h,
      width: 18.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget(text: heading, fontWeight: FontWeight.w600),
          SizedBox(height: 1.h),
          IntrinsicHeight(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText:hintText ,
                fillColor: Color(0xffF7FAFC),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffD1DBE8)),
                  borderRadius: BorderRadius.circular(15),
                ),),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUploadImagedButton(BuildContext context, String mealType) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () async {
        Provider.of<CloudinaryProvider>(context, listen: false)
            .setCurrentType(mealType);
        _pickAndUploadImage(context, mealType);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xffF7FAFC),
          border: Border.all(color: Color(0xffD1DBE1), width: 1),
        ),
        child: AppTextWidgetFira(
          text: 'Upload Image for $mealType',
          color: Color(0xff4F7396),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget buildImageDisplay(BuildContext context, String mealType,modelImage) {
    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context);
    final menuApp = Provider.of<MenuAppController>(context);
    log('sdsdasds ::  ${cloudinaryProvider.currentType}');
    Uint8List? imageData;
    switch (mealType) {
      case 'Breakfast':
        imageData = cloudinaryProvider.imageData;
        log('breakfast image data is :$imageData');
        break;
      case 'Lunch':
        imageData = cloudinaryProvider.luchImageData;
        log('Lunch image data is :$imageData');

        break;
      case 'Snack':
        imageData = cloudinaryProvider.snackImageData;
        log('Snack image data is :$imageData');

        break;
      case 'Dinner':
        imageData = cloudinaryProvider.dinnerImageData;
        log('Dinner image data is :$imageData');

        break;
    }

    return  Consumer<CloudinaryProvider>(
      builder: (context, provider, child) {
        return provider.imageData != null
            ? Container(
          height: 20.h,
          width: 20.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              provider.imageData!,
              fit: BoxFit.cover,
            ),
          ),
        )
            : Container(
            height: 20.h,
            width: 20.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            child:ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(menuApp.model!.imageUrl!,fit: BoxFit.cover,))
        );
      },
    );
  }

  Future<void> _pickAndUploadImage(
      BuildContext context, String mealType) async {
    final html.FileUploadInputElement uploadInput =
    html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // Accept only images

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);

      reader.onLoadEnd.listen((e) async {
        final bytes = reader.result as Uint8List;

        final cloudinaryProvider =
        Provider.of<CloudinaryProvider>(context, listen: false);
        cloudinaryProvider.setImageData(bytes);

        // Assign the image data to the respective meal field
        switch (mealType) {
          case 'Breakfast':
            _breakfastImageData = bytes;
            break;
          case 'Lunch':
            _lunchImageData = bytes;
            break;
          case 'Snack':
            _snackImageData = bytes;
            break;
          case 'Dinner':
            _dinnerImageData = bytes;
            break;
        }

        AppUtils().showToast(text: '$mealType image uploaded successfully');
      });
    });

    uploadInput.click(); // Trigger the file picker dialog
  }

  Future<void> _uploadMeal(
      BuildContext context,
      String mealType,
      TextEditingController mealController,
      TextEditingController proteinController,
      TextEditingController carbsController,
      TextEditingController fatController,
      TextEditingController recipeController,
      TextEditingController ingredientsController,
      TextEditingController recommendedController,
      TextEditingController descriptionController,
      Uint8List? mealImageData) async {

    ActionProvider.startLoading();  // Show loading indicator
    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
    final menuP = Provider.of<MenuAppController>(context, listen: false);

    if (mealController.text.isEmpty ||
        proteinController.text.isEmpty ||
        carbsController.text.isEmpty ||
        fatController.text.isEmpty ||
        recipeController.text.isEmpty ||
        ingredientsController.text.isEmpty ||
        recommendedController.text.isEmpty ||
        descriptionController.text.isEmpty ) {
      ActionProvider.stopLoading();  // Hide loading indicator
      AppUtils().showToast(text: 'Please fill all fields and upload an image');
      return;
    }

    try {
      await cloudinaryProvider.uploadImage(mealImageData!);
      // Upload the image to Cloudinary and get the image URL
      var mealId =  menuP.model!.id;

      if (cloudinaryProvider.imageUrl.isNotEmpty) {
        log('image url :: ${cloudinaryProvider.imageUrl}');
        // Save the meal data to Firestore
        await FirebaseFirestore.instance.collection('addMeal').doc(mealId).update({
          'mealType': mealType.toLowerCase(),
          'name': mealController.text,
          'protein': proteinController.text,
          'carbs': carbsController.text,
          'fat': fatController.text,
          'imageUrl': cloudinaryProvider.imageUrl.isNotEmpty ? cloudinaryProvider.imageUrl
          :menuP.model!.imageUrl,  // URL from Cloudinary
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'Id': mealId,
          'ingredients': ingredientsController.text,
          'recipe': recipeController.text,
          'recommended': recommendedController.text.toLowerCase() == 'yes' ? "true" : "false",
          'description': descriptionController.text,
          'likes': [],  // You can adjust this as necessary
        });

        ActionProvider.stopLoading();  // Hide loading indicator
        AppUtils().showToast(text: '$mealType uploaded successfully');
      } else {
        // await FirebaseFirestore.instance.collection('addMeal').doc(mealId).update({
        //   'mealType': mealType.toLowerCase(),
        //   'name': mealController.text,
        //   'protein': proteinController.text,
        //   'carbs': carbsController.text,
        //   'fat': fatController.text,
        //   'imageUrl': menuP.model!.imageUrl.toString(),  // URL from Cloudinary
        //   'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        //   'Id': mealId,
        //   'ingredients': ingredientsController.text,
        //   'recipe': recipeController.text,
        //   'recommended': recommendedController.text.toLowerCase() == 'yes' ? "true" : "false",
        //   'description': descriptionController.text,
        //   'likes': [],  // You can adjust this as necessary
        // });

        ActionProvider.stopLoading();  // Hide loading indicator
        AppUtils().showToast(text: '$mealType uploaded successfully');
      }
    } catch (e) {
      log('Error uploading $mealType: $e');
      ActionProvider.stopLoading();  // Hide loading indicator
      AppUtils().showToast(text: 'Failed to upload $mealType');
    }
  }


  Future<void> _updateMeal(BuildContext context) async {
    await _uploadMeal(
      context,
      'Breakfast',
      breakFastController,
      proteinController,
      carbsController,
      fatController,
      recipeController,
      ingredientsController,
      recommendedBreakfastController,
      descriptionBreakfastController,
      Provider.of<CloudinaryProvider>(context, listen: false).imageData,
    );
  }

}
