import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/components/add_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../constant.dart';
import '../../../controller/menu_App_Controller.dart';
import '../../../model/res/components/custom_appBar.dart';
import '../../../model/res/constant/app_utils.dart';
import '../../../model/res/routes/routes_name.dart';
import '../../../model/res/widgets/app_text.dart.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const CustomAppbar(text: 'Privacy Policy'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                InkWell(
                  hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  onTap: () {
                    Provider.of<MenuAppController>(context, listen: false)
                        .changeScreen(22);
                  },
                  child: AddButton(text: 'Add New Policy')
                ),
                SizedBox(
                  width: 2.w,
                ),
                InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                   // _showEditDialog(context, docId, privacyPolicy);
                  },
                  child: AddButton(text: 'Edit')
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('privacy').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // Check for loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Check for errors
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Check if the data is empty
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No privacy policies found'));
                }

                // Data exists, build the list
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var document = snapshot.data!.docs[index];
                    var privacyPolicy = document['privacy'];  // Assuming 'privacy' is the field storing the policy
                    var createdAt = (document['created_at'] as Timestamp).toDate();  // Convert Timestamp to DateTime

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: AppTextWidget(text: privacyPolicy,maxLines: 80,textAlign: TextAlign.start,fontWeight: FontWeight.w900,fontSize: 15,),
                        subtitle: AppTextWidget(text: 'Published on: ${createdAt.toString()}',maxLines: 80,textAlign: TextAlign.start,fontWeight: FontWeight.w900,fontSize: 15,),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          //          Padding(
 //            padding: const EdgeInsets.all(16.0),
 //            child: Container(
 //              height: 80.h,
 //              width: 90.w,
 //              child: ScrollConfiguration(
 //                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
 //                child: ListView(
 //                  shrinkWrap: true,
 //
 //                  scrollDirection: Axis.vertical,
 //                  children: [
 //                    AppTextWidget(text: '1.ABOUT',textAlign: TextAlign.start,underlinecolor: Colors.black,textDecoration: TextDecoration.underline,fontWeight: FontWeight.w900,fontSize: 15,),
 //                    AppTextWidget(
 //                      text: 'Figma, Inc. and its affiliates’ (“Figma,” “we,” “us,” and “our”) goal is to make design accessible to all. '
 //                          'This Privacy Policy will help you understand how we collect, use and share your personal information and assist'
 //                          ' you in exercising the privacy rights available to you.Capitalized terms not defined in this Privacy Policy have the meanings set forth in our Terms of Service.'
 //                      ,maxLines: 80,textAlign: TextAlign.start,fontWeight: FontWeight.w900,fontSize: 15,),
 //                    SizedBox(height: 3.h,),
 //                    AppTextWidget(text: '2.SCOPE',textAlign: TextAlign.start,underlinecolor: Colors.black,textDecoration: TextDecoration.underline,fontWeight: FontWeight.w900,fontSize: 15,),
 //                    AppTextWidget(
 //                      text: 'This Privacy Policy applies to personal information processed by us, '
 //                          'including on our websites (e.g., figma.com, designsystems.com and any other websites that we own or operate),'
 //                          ' our mobile applications, our application program interfaces, our design tool services, and our related online and '
 //                          'offline offerings (collectively, the “Services”).This Privacy Policy does not apply to any third-party websites, '
 //                          'services or applications, even if they are accessible through our Services. In addition, a separate privacy notice, '
 //                          'available upon request if it applies toyou, governs processing relating to our current employees and contractors.'
 //                      ,maxLines: 80,textAlign: TextAlign.start,fontWeight: FontWeight.w900,fontSize: 15,),                  SizedBox(height: 3.h,),
 // AppTextWidget(text: '3.Personal Information We Collect',underlinecolor: Colors.black,textAlign: TextAlign.start,textDecoration: TextDecoration.underline,fontWeight: FontWeight.w900,fontSize: 15,),
 //                    AppTextWidget(
 //                      text: 'The personal information we collect depends on how you interact with our Services.',maxLines: 80,textAlign: TextAlign.start,fontWeight: FontWeight.w900,fontSize: 15,),                  SizedBox(height: 3.h,),
 //
 //                    AppTextWidget(text: 'Information You Provide To Us',underlinecolor: Colors.black,textAlign: TextAlign.start,textDecoration: TextDecoration.underline,fontWeight: FontWeight.w900,fontSize: 15,),
 //                    AppTextWidget(
 //                      text: "Account Information.When you create a Figma account, we collect the personal information you provide to us, such as your name, email address, personal website, and picture. If you enable phone based two-factor authentication, we collect a phone number.Payment Information. Where we sell products and services through the Services, we use third-party applications, such as the Apple App Store, Google Play App Store, Amazon App Store, and/or services such as Stripe to process your payments. These third-party applications will collect information from you to process a payment on behalf of Figma, including your name, email address, mailing address, payment card information, and other billing information. Figma does not receive or store your payment information, but it may receive and store information associated with your payment information (e.g., the fact that you have paid, the last four digits or your credit card information, and your country of origin).Communication Information. We collect personal information from you such as email address, phone number,"
 //                          " mailing address, and marketing preferences when you request information about the Services, register for our newsletter, or otherwise communicate with us."
 //                           "Account Information.When you create a Figma account, we collect the personal information you provide to us, such as your name, email address, personal website, and picture. If you enable phone based two-factor authentication, we collect a phone number.Payment Information. Where we sell products and services through the Services, we use third-party applications, such as the Apple App Store, Google Play App Store, Amazon App Store, and/or services such as Stripe to process your payments. These third-party applications will collect information from you to process a payment on behalf of Figma, including your name, email address, mailing address, payment card information, and other billing information. Figma does not receive or store your payment information, but it may receive and store information associated with your payment information (e.g., the fact that you have paid, the last four digits or your credit card information, and your country of origin).Communication Information. We collect personal information from you such as email address, phone number,"
 //                          " mailing address, and marketing preferences when you request information about the Services, register for our newsletter, or otherwise communicate with us."
 //                           "Account Information.When you create a Figma account, we collect the personal information you provide to us, such as your name, email address, personal website, and picture. If you enable phone based two-factor authentication, we collect a phone number.Payment Information. Where we sell products and services through the Services, we use third-party applications, such as the Apple App Store, Google Play App Store, Amazon App Store, and/or services such as Stripe to process your payments. These third-party applications will collect information from you to process a payment on behalf of Figma, including your name, email address, mailing address, payment card information, and other billing information. Figma does not receive or store your payment information, but it may receive and store information associated with your payment information (e.g., the fact that you have paid, the last four digits or your credit card information, and your country of origin).Communication Information. We collect personal information from you such as email address, phone number,"
 //                          " mailing address, and marketing preferences when you request information about the Services, register for our newsletter, or otherwise communicate with us."
 //                          ,maxLines: 80,textAlign: TextAlign.start,fontWeight: FontWeight.w900,fontSize: 15,),                  SizedBox(height: 3.h,),
 //                  ]
 //                ),
 //              ),
 //            ),
 //          ),
        ],
      ),
    );
  }
  void _showEditDialog(BuildContext context, String docId, String currentPolicy) {
    final TextEditingController _editController = TextEditingController(text: currentPolicy);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Privacy Policy'),
          content: TextField(
            controller: _editController,
            maxLines: 5,
            decoration: const InputDecoration(hintText: 'Enter updated privacy policy'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),  // Close dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String updatedPolicy = _editController.text.trim();

                // Ensure the user entered some text
                if (updatedPolicy.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('privacy')
                        .doc(docId)
                        .update({'privacy': updatedPolicy});

                    Navigator.of(context).pop();  // Close dialog
                    AppUtils().showToast(text: 'Privacy policy updated successfully');
                  } catch (e) {
                    log("Error updating policy: $e");
                    AppUtils().showToast(text: 'Failed to update policy');
                  }
                } else {
                  AppUtils().showToast(text: 'Policy text cannot be empty');
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

}
