import 'dart:developer';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/widgets/app_text.dart.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/app_button_widget.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/cloudinary/cloudinary_provider.dart';
import '../../provider/meal/mealProvider.dart';

class EditMealPlan extends StatelessWidget {
  EditMealPlan({super.key});

  final TextEditingController mealNameController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController recipeController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController recommendedController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Uint8List? _imageData;

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context);
    final menuApp = Provider.of<MenuAppController>(context);

    final mealData = menuApp.model;

    // Pre-fill the fields if mealData exists
    if (mealData != null) {
      mealNameController.text = mealData.name ?? 'N/A';
      proteinController.text = mealData.protein ?? 'N/A';
      carbsController.text = mealData.carbs ?? 'N/A';
      fatController.text = mealData.fat ?? 'N/A';
      recipeController.text = mealData.recipe ?? 'N/A';
      ingredientsController.text = mealData.ingredients ?? 'N/A';
      recommendedController.text = mealData.recommended ?? 'N/A';
      descriptionController.text = mealData.description ?? 'N/A';
    }

    return Scaffold(
      appBar: CustomAppbar(text: 'Edit Meal Plan'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildMealFields(context,menuApp.model!.deitary,menuApp.model!.days,menuApp.model!.imageUrl),
              SizedBox(height: 2.h),
              Container(
                width: 40.w,
                child: ButtonWidget(
                  alignment: Alignment.centerRight,
                  text: 'Update Meal',
                  onClicked: () => _updateMeal(
                    context,
                    mealProvider,
                    cloudinaryProvider,
                    menuApp.model?.id,
                  ),
                  height: 5.h,
                  width: 10.w,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMealFields(BuildContext context,menuLabel,menuLabel2,image) {
    final mealProvider = Provider.of<MealProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildDropdownField(
              context: context,
              label: 'Dietary Category',
              value: menuLabel,
              options: ['Traditional', 'Vegan', 'Vegetarian'],
              onChanged: (newValue) {
                if (newValue != null) {
                  mealProvider.setCategory(newValue);
                }
              },

            ),
            SizedBox(width: 5.w),
            _buildDropdownField(
              context: context,
              label: 'Meal Plan Duration',
              value: menuLabel2,
              options: ['7 Days', '15 Days', '21 Days'],
              onChanged: (newValue) {
                if (newValue != null) {
                  mealProvider.setDays(newValue);
                }
              },

            ),
          ],
        ),
        SizedBox(height: 2.h),
        _buildTextField('Meal Name', mealNameController,width: 20.w),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTextField('Protein', proteinController, width: 10.w),
            SizedBox(width: 3.w,),
            _buildTextField('Carbs', carbsController, width: 10.w),
            SizedBox(width: 3.w,),
            _buildTextField('Fat', fatController, width: 10.w),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            _buildTextField('Recipe', recipeController, width: 25.w),
            SizedBox(width: 3.w,),
            _buildTextField('Ingredients', ingredientsController,width:25.w ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            _buildTextField('Recommended', recommendedController,width: 25.w),
            SizedBox(width: 3.w,),
            _buildTextField('Description', descriptionController, width: 25.w),
          ],
        ),
        SizedBox(height: 2.h),
        _buildUploadImageSection(context,image,),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      { double? width}) {
    return Container(
      width: width ?? double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1.h),
          IntrinsicHeight(
            child: TextField(
              expands: true,
              maxLines: null,
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffF7FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required String? value,
    required List<String> options,
     required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: 15.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget(text: label, fontWeight: FontWeight.bold),
          SizedBox(height: 1.h),
          DropdownButtonFormField<String>(
            value: value,
            items: options
                .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF7FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadImageSection(BuildContext context,image) {
    final cloudinaryProvider = Provider.of<CloudinaryProvider>(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        cloudinaryProvider.imageData != null
            ? Image.memory(
          cloudinaryProvider.imageData!,
          height: 20.h,
          width: 20.w,
          fit: BoxFit.cover,
        )
            : Image.network(image, height: 20.h,
          width: 20.w,
          fit: BoxFit.cover,),
        SizedBox(width: 2.h),
        AppButtonWidget(
          onPressed: () => _pickAndUploadImage(context),
          text: 'Change Image',
          height: 5.h,
          width: 10.w,
          radius: 30.h,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';

    uploadInput.onChange.listen((event) async {
      final files = uploadInput.files;
      if (files == null || files.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);

      reader.onLoadEnd.listen((event) async {
        _imageData = reader.result as Uint8List;
        final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
        cloudinaryProvider.setImageData(_imageData!);
        AppUtils().showToast(text: 'Image uploaded successfully');
      });
    });

    uploadInput.click();
  }

  Future<void> _updateMeal(
      BuildContext context,
      MealProvider mealProvider,
      CloudinaryProvider cloudinaryProvider,
      String? mealId,
      ) async {
    if (mealId == null) {
      AppUtils().showToast(text: 'Meal ID is missing. Cannot update.');
      return;
    }

    ActionProvider.startLoading();

    try {
      // Map to hold updated fields
      final Map<String, dynamic> updates = {};

      // Check each field and add to updates map only if it has changed
      final mealData = Provider.of<MenuAppController>(context, listen: false).model;

      if (mealNameController.text != mealData?.name) {
        updates['name'] = mealNameController.text;
        log("name iss:: ${updates['name']}");
        log("name data iss:: ${mealData?.name}");
      }
      if (proteinController.text != mealData?.protein) {
        updates['protein'] = proteinController.text;
        log("protein iss:: ${updates['protein']}");
        log("protein data iss:: ${mealData?.protein}");

      }
      if (carbsController.text != mealData?.carbs) {
        updates['carbs'] = carbsController.text;
        log("carbs iss:: ${updates['carbs']}");
        log("carbs data iss:: ${mealData?.carbs}");
      }
      if (fatController.text != mealData?.fat) {
        updates['fat'] = fatController.text;
        log("fat iss:: ${updates['fat']}");
        log("fat data iss:: ${mealData?.fat}");

      }
      if (recipeController.text != mealData?.recipe) {
        updates['recipe'] = recipeController.text;
        log("recipe iss:: ${updates['recipe']}");
        log("recipe data iss:: ${mealData?.recipe}");
      }
      if (ingredientsController.text != mealData?.ingredients) {
        updates['ingredients'] = ingredientsController.text;
        log("ingredients iss:: ${updates['ingredients']}");
        log("ingredients data iss:: ${mealData?.ingredients}");
      }
      if (recommendedController.text != mealData?.recommended) {
        updates['recommended'] = recommendedController.text.toLowerCase();
        log("recommended iss:: ${updates['recommended']}");
        log("recommended data iss:: ${mealData?.recommended}");
      }
      if (descriptionController.text != mealData?.description) {
        updates['description'] = descriptionController.text;
        log("description iss:: ${updates['description']}");
        log("description data iss:: ${mealData?.description}");
      }
      if (mealProvider.selectedCategory?.isNotEmpty == true &&
          mealProvider.selectedCategory != mealData?.deitary) {
        updates['mealCategory'] = mealProvider.selectedCategory;
        log("mealCategory iss:: ${updates['mealCategory']}");
        log("mealCategory data iss:: ${mealData?.deitary}");
      }
      if (mealProvider.selectedMealType?.isNotEmpty == true &&
      mealProvider.selectedMealType != mealData?.mealType) {
        updates['mealType'] = mealProvider.selectedMealType.toString().isEmpty ? mealProvider.selectedMealType : mealData?.mealType;
        log("mealType iss:: ${updates['mealType']}");
        log("mealType data iss:: ${mealData?.mealType}");
      }
      if (mealProvider.selectedDays != mealData?.days) {
        updates['days'] = mealProvider.selectedDays?.isNotEmpty == true
            ? mealProvider.selectedDays
            : mealData?.days;
        log("days iss:: ${updates['days']}");
        log("days data iss:: ${mealData?.days}");
      }


      // Check if a new image has been uploaded
      if (_imageData != null) {
        // Upload image to Cloudinary
        await cloudinaryProvider.uploadImage(_imageData!);
        if (cloudinaryProvider.imageUrl.isNotEmpty) {
          updates['imageUrl'] = cloudinaryProvider.imageUrl;
          log('Image uploaded to Cloudinary: ${cloudinaryProvider.imageUrl}');
        } else {
          log('Image upload failed: Cloudinary URL is empty.');
        }
      } else if (mealProvider.mealImage?.isNotEmpty == true &&
          mealProvider.mealImage != mealData?.imageUrl) {
        updates['imageUrl'] = mealProvider.mealImage;
        log('Image updated to Firestore: ${mealProvider.mealImage}');
      }


      // Perform update only if there are changes
      if (updates.isNotEmpty) {
        await FirebaseFirestore.instance.collection('addMeal').doc(mealId).update(updates);
        AppUtils().showToast(text: 'Meal updated successfully');
        //clear
        mealNameController.clear();
        proteinController.clear();
        carbsController.clear();
        fatController.clear();
        recipeController.clear();
        ingredientsController.clear();
        recommendedController.clear();
        descriptionController.clear();
        mealProvider.clearMealData();
        _imageData = null;
      } else {
        AppUtils().showToast(text: 'No changes detected');
      }
    } catch (e) {
      log('Error updating meal: $e');
      AppUtils().showToast(text: 'Failed to update meal');
    } finally {
      ActionProvider.stopLoading();
    }
  }

}
