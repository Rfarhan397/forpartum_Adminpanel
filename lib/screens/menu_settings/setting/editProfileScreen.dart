import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/constant.dart';
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

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the provider's data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ProfileInfoProvider>(context, listen: false);
      nameController.text = profileProvider.profileName ?? 'N/A';
      emailController.text = profileProvider.profileEmail ?? 'N/A';
      addressController.text = profileProvider.profileAddress ?? 'N/A';
      phoneController.text = profileProvider.profilePhone ?? 'N/A';
      roleController.text = profileProvider.profileRole ?? 'N/A';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(text: 'Profile'),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: Consumer2<ProfileInfoProvider, CloudinaryProvider>(
          builder: (context, profileProvider, cloudinaryProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: Colors.grey),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: cloudinaryProvider.imageData != null
                          ? MemoryImage(cloudinaryProvider.imageData!)
                          : (profileProvider.profileImageUrl != null
                          ? NetworkImage(profileProvider.profileImageUrl!)
                          : const AssetImage(AppAssets.logoImage)) as ImageProvider,
                    ),
                    SizedBox(width: 5.w),
                    InkWell(
                      onTap: () {
                        Provider.of<ActionProvider>(context, listen: false).pickAndUploadImage(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: primaryColor),
                          SizedBox(width: 1.w),
                          AppTextWidget(text: 'Edit Profile', fontSize: 18, color: primaryColor),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    textWithField('Name:', nameController),
                    SizedBox(width: 5.w),
                    textWithField('Email:', emailController),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    textWithField('Phone:', phoneController),
                    SizedBox(width: 5.w),
                    textWithField('Role:', roleController),
                  ],
                ),
                SizedBox(height: 5.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: ButtonWidget(
                    text: 'Update',
                    onClicked: () async {
                      await _uploadData(context);
                      },
                    width: 10.w,
                    height: 5.h,
                    fontWeight: FontWeight.w400,
                    radius: 50,
                  ),
                ),
              ],
            );
          },
        ),
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

    if ([nameController.text, emailController.text, phoneController.text, roleController.text]
        .any((field) => field.isEmpty) ||
        cloudinaryProvider.imageData == null) {
      ActionProvider.stopLoading();
      AppUtils().showToast(text: 'Please fill all fields or upload an image');
      return;
    }

    try {
      await cloudinaryProvider.uploadImage(cloudinaryProvider.imageData!);
      log('Image URL: ${cloudinaryProvider.imageUrl}');
      if (cloudinaryProvider.imageUrl.isNotEmpty) {
        // Replace hard-coded document ID with a dynamic user ID if applicable

        await FirebaseFirestore.instance.collection('admin').doc('d7vRqxlJm1Qg2BB04ILb058YoRw1').update({
          'name': nameController.text,
          'email': emailController.text,
          'address': addressController.text,
          'phone': phoneController.text,
          'imageUrl': cloudinaryProvider.imageUrl.toString(),
          'role': roleController.text,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        });
        ActionProvider.stopLoading();
        AppUtils().showToast(text: 'Data uploaded successfully');
        //clear
        nameController.clear();
        emailController.clear();
        addressController.clear();
        phoneController.clear();
        roleController.clear();
        cloudinaryProvider.clearImage();
      } else {
        ActionProvider.stopLoading();
        cloudinaryProvider.clearImage();
        AppUtils().showToast(text: 'Image upload failed');
      }
    } catch (e) {
      log('Error uploading Data: $e');
      ActionProvider.stopLoading();
      cloudinaryProvider.clearImage();
      AppUtils().showToast(text: 'Failed to upload Data');
    }
  }

  Widget textWithField(String name, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget(text: name),
        SizedBox(height: 1.h),
        SizedBox(
          width: 20.w, // Ensure this width adapts as needed for smaller screens
          child: AppTextFieldBlue(
            controller: controller,
            hintText: controller.text
          ),
        ),
      ],
    );
  }
}
