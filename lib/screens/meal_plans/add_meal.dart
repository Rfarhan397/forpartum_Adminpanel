import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/components/app_button_widget.dart';
import 'package:forpartum_adminpanel/model/res/constant/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/app_text_field.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/cloudinary/cloudinary_provider.dart';
import '../../provider/meal/mealProvider.dart';

class AddMealScreen extends StatelessWidget {
   AddMealScreen({Key? key}) : super(key: key);

   Uint8List? _imageData;

   TextEditingController mealController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController recipeController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController recommendedController =
  TextEditingController();
  TextEditingController descriptionController =
  TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);

    return Scaffold(
      appBar: CustomAppbar(text: 'Add Meal Plan'),
      body: Column(
        children: [
          Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildSelectButton(
                          context: context,
                          title: "Meal Type",
                          heading: "Select Meal Type",
                          value: mealProvider.selectedMealType,
                          options: ['breakfast', 'lunch', 'snack', 'dinner'],
                          onSelected: (value) => mealProvider.setMealType(value),
                        ),
                        SizedBox(width: 5.h),
                        _buildSelectButton(
                          context: context,
                          title: "Dietary Category",
                          heading: "Select Dietary Category",
                          value: mealProvider.selectedCategory,
                          options: ['Traditional', 'Vegan', 'Vegetarian'],
                          onSelected: (value) => mealProvider.setCategory(value),
                        ),
                        SizedBox(width: 5.h),
                        _buildSelectButton(
                          context: context,
                          title: "Meal Plan Duration",
                          heading: "Select Meal Plan Duration",

                          value: mealProvider.selectedDays,
                          options: ['7 Days', '15 Days', '21 Days'],
                          onSelected: (value) => mealProvider.setDays(value),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    IntrinsicHeight(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField("Meal Name","Basic",mealController),
                            _buildNutrientFields(),
                            Container(
                              height: 50.h,
                              child: Row(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildTextFieldF("Recipe","Recipe",recipeController),
                                        _buildTextFieldF("Ingredients","Ingredients",ingredientsController),
                                        _buildTextFieldF("Description","Description",descriptionController),
                                        SizedBox(height: 1.h,),
                                        _buildRecommendedRadioButtons(context,mealProvider),
                                    
                                    
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5.w,),
                                  _buildUploadImageSection(context, mealProvider),

                                ],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            ButtonWidget(
                              fontWeight: FontWeight.w600,
                              height: 5.h,
                              width: 10.w,
                              alignment: Alignment.centerRight,
                              onClicked: () {
                                _saveMeal(context, mealProvider);
                              },
                              text: 'Save Meal',
                              radius: 10.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectButton({
    required BuildContext context,
    required String title,
    required String heading,
    required String? value,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    return Row(
      children: [
        AppTextWidget(text:
        heading,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(width: 2.h,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: value,
            hint: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
            dropdownColor: Theme.of(context).primaryColor, // Dropdown menu background color
            style: TextStyle(color: Colors.white), // Text color inside dropdown
            underline: SizedBox.shrink(), // Removes the underline
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            items: options
                .map((option) => DropdownMenuItem<String>(
              value: option,
              child: Text(option, style: TextStyle(color: Colors.white)),
            ))
                .toList(),
            onChanged: (newValue) => onSelected(newValue!),
          ),
        ),
      ],
    );
  }

   Widget _buildNutrientFields() {
     return Row(
       mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         _buildTextField("Protein", "Protein", proteinController),
         SizedBox(width: 2.w),
         _buildTextField("Carbs", "Carbs", carbsController),
         SizedBox(width: 2.w),
         _buildTextField("Fat", "Fat", fatController),
       ],
     );
   }
   Widget _buildTextField(String label,hintText,TextEditingController controller,) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 8.0),
       child: SizedBox(
         width: 10.w,
         height: 100,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             AppTextWidget(text: label, fontWeight: FontWeight.w600),
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
                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Color(0xffD1DBE8)),
                   borderRadius: BorderRadius.circular(15),
                 ),
                 hintText: hintText,
                 hintStyle:
                 TextStyle(fontSize: 16, color: Color(0xff4F7396)),
               ),
             ),
           ],
         ),
       ),
     );
   }
   Widget _buildRecommendedRadioButtons(BuildContext context, MealProvider mealProvider) {
     return Row(
       children: [
         AppTextWidget(
           text: "Recommended:",
           fontSize: 18,
           fontWeight: FontWeight.w500,
         ),
         SizedBox(width: 2.h),
         Row(
           children: [
             Row(
               children: [
                 Radio<String>(
                   value: 'yes',
                   groupValue: mealProvider.selectedRecommended,
                   onChanged: (value) => mealProvider.setRecommended(value!),
                 ),
                 AppTextWidget(
                   text: "Yes",
                   fontSize: 16,
                 ),
               ],
             ),
             Row(
               children: [
                 Radio<String>(
                   value: 'no',
                   groupValue: mealProvider.selectedRecommended,
                   onChanged: (value) => mealProvider.setRecommended(value!),
                 ),
                 AppTextWidget(
                   text: "No",
                   fontSize: 16,
                 ),
               ],
             ),
           ],
         ),
       ],
     );
   }

   Widget _buildTextFieldF(
       String label,
       String hintText,
       TextEditingController controller,
       ) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 8.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           AppTextWidget(text: label, fontWeight: FontWeight.w600),
           SizedBox(height: 1.h),
           Container(
             width: 30.w, // Adjust width as needed
             child: IntrinsicHeight(
               child: TextField(
                 controller: controller,
                 expands: true,
                 maxLines: null,
                 decoration: InputDecoration(
                   fillColor: const Color(0xffF7FAFC),
                   filled: true,
                   enabledBorder: OutlineInputBorder(
                     borderSide: const BorderSide(color: Color(0xffD1DBE8)),
                     borderRadius: BorderRadius.circular(15),
                   ),
                   focusedBorder: OutlineInputBorder(
                     borderSide: const BorderSide(color: Color(0xffD1DBE8)),
                     borderRadius: BorderRadius.circular(15),
                   ),
                   hintText: hintText,
                   hintStyle: const TextStyle(
                     fontSize: 16,
                     color: Color(0xff4F7396),
                   ),
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }

   Future<void> _pickAndUploadImage(BuildContext context) async {
     final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
     uploadInput.accept = 'image/*'; // Accept only images

     uploadInput.onChange.listen((e) async {
       final files = uploadInput.files;
       if (files!.isEmpty) return;

       final file = files[0];
       final fileSizeInBytes = file.size; // Get the file size in bytes
       final maxFileSizeInBytes = 5 * 1024 * 1024; // 5 MB in bytes

       if (fileSizeInBytes > maxFileSizeInBytes) {
         AppUtils().showToast(text: 'Image size exceed to 5 MB');
         return;
       }

       final reader = html.FileReader();
       reader.readAsArrayBuffer(file);

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

   Widget _buildUploadImageSection(BuildContext context, MealProvider mealProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              child: const Center(
                child: AppTextWidget(text:
                'No image selected',
                    color: Colors.grey),
              ),
            );
          },
        ),
        AppTextWidget(text: 'Image size shoul not exceed 5 mb',fontSize: 12,color: Colors.grey,),
        SizedBox(height: 10),
        AppButtonWidget(
            width: 10.w,
            height: 5.h,
            radius: 8,
            onPressed: () async {
              _pickAndUploadImage(context);
            },
            text: 'Upload Image'),

      ],
    );
  }

   void _saveMeal(BuildContext context, MealProvider mealProvider) async {
     final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);

     ActionProvider.startLoading();  // Show loading indicator
     final batch = FirebaseFirestore.instance.batch();

     var mealId = FirebaseFirestore.instance.collection('addMeal').doc().id.toString();

     // Check for null or empty values
     if (mealProvider.selectedMealType == null || mealProvider.selectedMealType!.isEmpty) {
       log("Meal type is null or empty");
     }
     if (mealProvider.selectedRecommended == null || mealProvider.selectedRecommended!.isEmpty) {
       log("Recommended value is null or empty");
     }
     if (mealProvider.selectedDays == null || mealProvider.selectedDays!.isEmpty) {
       log("Selected days value is null or empty");
     }
     if (mealController.text.isEmpty) {
       log("Meal name is empty");
     }
     if (proteinController.text.isEmpty) {
       log("Protein value is empty");
     }
     if (carbsController.text.isEmpty) {
       log("Carbs value is empty");
     }
     if (fatController.text.isEmpty) {
       log("Fat value is empty");
     }
     if (recipeController.text.isEmpty) {
       log("Recipe value is empty");
     }
     if (ingredientsController.text.isEmpty) {
       log("Ingredients value is empty");
     }
     if (descriptionController.text.isEmpty) {
       log("Description value is empty");
     }
     if (mealProvider.selectedCategory == null || mealProvider.selectedCategory!.isEmpty) {
       log("Meal category is null or empty");
     }

     // Check if any required field is empty
     if (mealProvider.selectedMealType!.isEmpty ||
         mealProvider.selectedRecommended!.isEmpty ||
         mealProvider.selectedDays!.isEmpty ||
         mealController.text.isEmpty ||
         proteinController.text.isEmpty ||
         carbsController.text.isEmpty ||
         fatController.text.isEmpty ||
         recipeController.text.isEmpty ||
         ingredientsController.text.isEmpty ||
         descriptionController.text.isEmpty ||
         mealProvider.selectedCategory!.isEmpty) {
       ActionProvider.stopLoading();
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Please select meal type and category")),
       );
       return;
     }

     try {
       await cloudinaryProvider.uploadImage(cloudinaryProvider.imageData!);
       if(cloudinaryProvider.imageUrl.isNotEmpty){
         final mealData = {
           'id': mealId,
           'name': mealController.text.trim(),
           'protein': proteinController.text.trim(),
           'carbs': carbsController.text.trim(),
           'fat': fatController.text.trim(),
           'imageUrl': cloudinaryProvider.imageUrl,
           'description': descriptionController.text.trim(),
           'recipe': recipeController.text.trim(),
           'ingredients': ingredientsController.text.trim(),
           'mealType': mealProvider.selectedMealType,
           'mealCategory': mealProvider.selectedCategory,
           'days': mealProvider.selectedDays,
           'recommended': mealProvider.selectedRecommended,
           'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
           'likes':[],
         };
         batch.set(FirebaseFirestore.instance.collection('addMeal').doc(mealId), mealData);
         await batch.commit();
         AppUtils().showToast(text: "Meal saved successfully!");
         //clear controllers
         proteinController.clear();
         carbsController.clear();
         fatController.clear();
         recipeController.clear();
         ingredientsController.clear();
         descriptionController.clear();
         mealController.clear();
         cloudinaryProvider.clearImage();
         mealProvider.clearMealData();
         mealProvider.selectedRecommended = '';
       }
       else {
         ActionProvider.stopLoading();
         AppUtils().showToast(text: 'Image upload failed',);
       }
     } catch (e) {
       log("Error saving meal: $e");
       AppUtils().showToast(text: "Error saving meal: $e");
     }
     ActionProvider.stopLoading();
   }
}
