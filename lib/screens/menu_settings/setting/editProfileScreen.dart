import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/constant.dart';
import 'package:forpartum_adminpanel/main.dart';
import 'package:forpartum_adminpanel/model/res/components/custom_appBar.dart';
import 'package:forpartum_adminpanel/model/res/constant/app_assets.dart';
import 'package:forpartum_adminpanel/model/res/constant/app_utils.dart';
import 'package:forpartum_adminpanel/model/res/widgets/app_text.dart.dart';
import 'package:forpartum_adminpanel/model/res/widgets/app_text_field.dart';
import 'package:forpartum_adminpanel/model/res/widgets/button_widget.dart';
import 'package:forpartum_adminpanel/provider/cloudinary/cloudinary_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../provider/action/action_provider.dart';
import '../../../provider/profileInfo/profileInfoProvider.dart';

class EditProfileScreen extends StatelessWidget {
   EditProfileScreen({super.key});


  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController roleController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: 'Profile',),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.grey,),
          Padding(
            padding:  EdgeInsets.all(4.w),
            child: SizedBox(
              width: 50.w,
              child: Consumer2<ProfileInfoProvider,CloudinaryProvider>(
                builder: (context, value,provider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: provider.imageData != null
                                ? MemoryImage(provider.imageData!)
                                : value.profileImageUrl != null
                                ? NetworkImage(value.profileImageUrl!) // Use NetworkImage if imageUrl is available
                                : const AssetImage(AppAssets.logoImage) as ImageProvider,
                          ),
                          SizedBox(width: 5.w,),
                          InkWell(
                            onTap: () {
                              Provider.of<ActionProvider>(context,listen: false).pickAndUploadImage(context);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.edit,color: primaryColor,),
                                SizedBox(width:1.w),
                                AppTextWidget(text: 'Edit Profile',fontSize: 18,color: primaryColor,),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h,),
                      Row(
                        children: [
                          textWithField('Name:',value.profileName !=null ?  nameController.text = value.profileName.toString() : "Enter First Name",nameController),
                          SizedBox(width: 5.w,),
                          textWithField('Email:',value.profileEmail !=null ?  emailController.text = value.profileEmail.toString() : "Enter Email",emailController),
                        ],
                      ),
                      SizedBox(height: 3.h,),
                      Row(
                        children: [
                          textWithField('Phone:',value.profileEmail !=null ?  phoneController.text = value.profilePhone.toString() : "Enter Phone",phoneController),
                          SizedBox(width: 5.w,),
                          textWithField('Role:',value.profileRole !=null ?  roleController.text = value.profileRole.toString() : "Enter Role",roleController),

                        ],
                      ),
                      SizedBox(height: 5.h,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ButtonWidget(text: 'Update',
                          onClicked: () async{
                            _uploadData(context);
                          },
                          width: 10.w,
                          height: 5.h,
                          fontWeight: FontWeight.w400,
                          radius: 50,
                        ),
                      )
                    ],
                  );
                },),
            ),
          )
        ],
      ),
    );
  }


   Future<void> _uploadData(BuildContext context) async {
     ActionProvider.startLoading();
     final cloudinaryProvider = Provider.of<CloudinaryProvider>(context, listen: false);
     log(nameController.text);
     log(emailController.text);
     log(phoneController.text);
     log(roleController.text);
     if (nameController.text.isEmpty ||
         emailController.text.isEmpty ||
         phoneController.text.isEmpty ||
         roleController.text.isEmpty ||
         cloudinaryProvider.imageData == null) {
       ActionProvider.stopLoading();
       AppUtils().showToast(text: 'Please fill all fields or upload an image',);
       return;
     }

     try {
       await cloudinaryProvider.uploadImage(cloudinaryProvider.imageData!);
       log('Image URL: ${cloudinaryProvider.imageUrl}');
       if (cloudinaryProvider.imageUrl.isNotEmpty) {
         //  Save the data to Firebase
         // Example Firebase code:
         await FirebaseFirestore.instance.collection('admin').doc("d7vRqxlJm1Qg2BB04ILb058YoRw1").update({
           'name': nameController.text,
           'email': emailController.text,
           'address': addressController.text,
           'phone': phoneController.text,
           'imageUrl': cloudinaryProvider.imageUrl.toString(),
           'role': roleController.text.toString(),
           'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
         });
         ActionProvider.stopLoading();


         AppUtils().showToast(text: 'Data uploaded successfully');
       } else {
         ActionProvider.stopLoading();
         cloudinaryProvider.clearImage();
         AppUtils().showToast(text: 'Image upload failed',);
       }
     } catch (e) {
       log('Error uploading Data: $e');
       ActionProvider.stopLoading();
       cloudinaryProvider.clearImage();
       AppUtils().showToast(text:'Failed to upload Data', );
     }
   }
}
Widget textWithField(String name, String? hint,TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppTextWidget(text: name),
      SizedBox(height: 1.h),
      SizedBox(
        width: 20.w, // Set a width to control layout
        child: AppTextFieldBlue(
            controller: controller,
            hintText: hint ?? ""),
      ),
    ],
  );
}

