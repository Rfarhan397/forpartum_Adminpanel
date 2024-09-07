import 'dart:developer';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../model/res/components/app_button_widget.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/cloudinary/cloudinary_provider.dart';

class AddMealScreen extends StatelessWidget {
  AddMealScreen({super.key});
  Uint8List? _imageData; // Store image data
  Uint8List? _breakfastImageData;
  Uint8List? _lunchImageData;
  Uint8List? _snackImageData;
  Uint8List? _dinnerImageData;
  TextEditingController breakFastController = TextEditingController();
  TextEditingController lunchController = TextEditingController();
  TextEditingController snackController = TextEditingController();
  TextEditingController dinnerController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController recipeController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController lunchProteinController = TextEditingController();
  TextEditingController lunchCarbsController = TextEditingController();
  TextEditingController lunchFatController = TextEditingController();
  TextEditingController lunchRecipeController = TextEditingController();
  TextEditingController lunchIngredientsController = TextEditingController();
  TextEditingController snackProteinController = TextEditingController();
  TextEditingController snackCarbsController = TextEditingController();
  TextEditingController snackFatController = TextEditingController();
  TextEditingController snackRecipeController = TextEditingController();
  TextEditingController snackIngredientsController = TextEditingController();
  TextEditingController dinnerProteinController = TextEditingController();
  TextEditingController dinnerCarbsController = TextEditingController();
  TextEditingController dinnerFatController = TextEditingController();
  TextEditingController dinnerRecipeController = TextEditingController();
  TextEditingController dinnerIngredientsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: 'Mother Essence Plan'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppButtonWidget(
              width: 120,
              alignment: Alignment.centerRight,
              onPressed: () {
                _uploadMeal(context);
              },
              text: 'Upload',
              radius: 20,
            ),
            Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: primaryColor,
              ),
              child: Center(
                child: AppTextWidget(
                  text: 'Day 1',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      buildMealFields(
                        context,
                        'Breakfast',
                        breakFastController,
                        proteinController,
                        carbsController,
                        fatController,
                        recipeController,
                        ingredientsController,
                      ),
                      buildMealFields(context,
                        'Lunch',
                        lunchController,
                        lunchProteinController,
                        lunchCarbsController,
                        lunchFatController,
                        lunchRecipeController,
                        lunchIngredientsController,
                      ),
                      buildMealFields(context,
                        'Snack',
                        snackController,
                        snackProteinController,
                        snackCarbsController,
                        snackFatController,
                        snackRecipeController,
                        snackIngredientsController,
                      ),
                      buildMealFields(
                        context,
                        'Dinner',
                        dinnerController,
                        dinnerProteinController,
                        dinnerCarbsController,
                        dinnerFatController,
                        dinnerRecipeController,
                        dinnerIngredientsController,
                      ),
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
      String heading,
      TextEditingController mealController,
      TextEditingController proteinController,
      TextEditingController carbsController,
      TextEditingController fatController,
      TextEditingController recipeController,
      TextEditingController ingredientsController,
      ) {
    return Column(
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
                        hintText: 'Mother Essence',
                        hintStyle: TextStyle(fontSize: 16, color: Color(0xff4F7396)),
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
                    buildNutrientField(proteinController, 'Protein', '20'),
                    buildNutrientField(carbsController, 'Carbs', '30'),
                    buildNutrientField(fatController, 'Fat', '4'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            buildTextFieldColumn('Recipe', recipeController),
            SizedBox(width: 5.w),
            buildTextFieldColumn('Ingredients', ingredientsController),
            SizedBox(width: 5.w),
            buildUploadImagedButton(context,heading),
            SizedBox(width: 0.5.w),
            buildImageDisplay(context,heading,), // Display corresponding image

          ],
        ),
      ],
    );
  }

  Widget buildNutrientField(TextEditingController controller, String heading, String hintText) {
    return SizedBox(
      width: 10.w,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget(text: heading, fontWeight: FontWeight.w600),
          SizedBox(height: 1.h),
          TextField(
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
        ],
      ),
    );
  }

  Widget buildTextFieldColumn(String heading, TextEditingController controller) {
    return Container(
      height: 30.h,
      width: 18.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget(text: heading, fontWeight: FontWeight.w400, fontSize: 14),
          SizedBox(height: 3.h),
          TextFormField(
            maxLines: 6,
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUploadImagedButton(BuildContext context, String mealType) {
    return GestureDetector(
     onTap: () async{
       _pickAndUploadImage(context,mealType);
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
//this is for showing image in the container
  Widget buildImageDisplay(BuildContext context,String mealType) {
    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context);

    Uint8List? imageData;
    switch (mealType) {
      case 'Breakfast':
        imageData = cloudinaryProvider.imageData;
        break;
      case 'Lunch':
        imageData = cloudinaryProvider.luchImageData;
        break;
      case 'Snack':
        imageData = cloudinaryProvider.snackImageData;
        break;
      case 'Dinner':
        imageData = cloudinaryProvider.dinnerImageData;
        break;
    }

    return imageData != null
        ? Container(
      height: 20.h,
      width: 20.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Image.memory(
        imageData,
        fit: BoxFit.cover,
      ),
    )
        : Container(
      height: 20.h,
      width: 20.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: AppTextWidget(
          text: 'No image selected',
          color: Colors.grey,
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context, String mealType) async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // Accept only images

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);

      reader.onLoadEnd.listen((e) async {
        final bytes = reader.result as Uint8List;

        final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
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


  Future<void> _uploadMeal(BuildContext context) async {
    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
    log('breakfast:${breakFastController.text.toString()}');
    log('protein:${proteinController.text.toString()}');
    log('image:$_imageData');
    log('carbs:${carbsController}');
    log('fat:${fatController}');
    if (breakFastController.text.isEmpty ||
        proteinController.text.isEmpty ||
        carbsController.text.isEmpty ||fatController.text.isEmpty||
        cloudinaryProvider.imageData == null) {
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Please fill all fields and upload an image',);
      return;
    }

    try {
      await cloudinaryProvider.uploadImage(cloudinaryProvider.imageData!);
      var id = FirebaseFirestore.instance.collection('addMeal').doc().id.toString();
      if (cloudinaryProvider.imageUrl.isNotEmpty) {
        //  Save the Meal data to Firebase
        // Example Firebase code:
        await FirebaseFirestore.instance.collection('addMeal').doc(id).set({
          'name': breakFastController.text,
          'protein': proteinController.text,
          'carbs': carbsController.text,
          'fat': fatController.text,
          'imageUrl': cloudinaryProvider.imageUrl.toString(),
          'createdAt': Timestamp.now(),
          'Id': id.toString(),

        });
        ActionProvider.stopLoading();
        AppUtils().showToast(text: 'Meal uploaded successfully');
      } else {
        ActionProvider.stopLoading();
        AppUtils().showToast(text: 'Image upload failed',);
      }
    } catch (e) {
      log('Error uploading Meal: $e');
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Failed to upload Meal', );
    }
  }
}
