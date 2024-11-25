import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/widgets/hover_button_loader.dart';
import 'package:forpartum_adminpanel/provider/action/action_provider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/custom_dropDown.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/app_text_field.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/dropDOwn/dropdown.dart';

class AddNotification extends StatelessWidget {
   AddNotification({super.key});
TextEditingController _titleController = TextEditingController();
TextEditingController _messageController = TextEditingController();
TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: const CustomAppbar(text: 'Create New Notification'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 10,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 400,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppTextWidget(text: 'Title',fontWeight: FontWeight.w500,fontSize: 18,),
                          SizedBox(height: 1.h,),
                          AppTextFieldBlue(hintText: 'Input Field',controller: _titleController,),
                          const AppTextWidget(text: 'Message',fontWeight: FontWeight.w500,fontSize: 18),
                          SizedBox(height: 1.h,),
                          AppTextFieldBlue(hintText: 'Input Field',controller: _messageController,),
                        ],
                      )
                    ),
                    SizedBox(width: 5.w,),
                    // Container(
                    //   height: 70,
                    //   alignment: Alignment.center,
                    //   child:  Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       //buildDropDown(context, 2),
                    //
                    //       // Consumer<DropdownProviderN>(
                    //       //   builder: (context, dropdownProvider, child) {
                    //       //     return CustomDropdownWidget(
                    //       //       index: 2,
                    //       //       items: [ 'Email', 'SMS', 'Push Notification ',],
                    //       //      dropdownType: 'Type',
                    //       //     );
                    //       //   },
                    //       // ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 4.h,),
                Container(
                  width: 45.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   height: 50.h,
                      //   width: 45.w,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(10),
                      //     border: Border.all(color: Colors.black),
                      //   ),
                      //   child:  Padding(
                      //     padding: EdgeInsets.all(8.0),
                      //     child: TextField(
                      //       controller: _descriptionController,
                      //       maxLines: null,
                      //       expands: true,
                      //       decoration: InputDecoration(
                      //         border: InputBorder.none,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppTextWidget(text: 'Schedule:'),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: HoverLoadingButton(
                                  onClicked: () async{
                                    Provider.of<MenuAppController>(context, listen: false)
                                        .changeScreen(6);
                                  },
                                  text:('Cancel'),
                                  isIcon: false,
                                  index: 1,
                                  loader: false,
                                  backgroundColor: secondaryColor,
                                  borderColor: secondaryColor,
                                  height: 4.h,
                                  width: 8.w,
                                  textColor: Colors.white,
                                  radius: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 1.5.w,),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ButtonWidget(
                                  onClicked: () {
                                    sendNotification(
                                      _titleController.text.toString(),
                                      _messageController.text.toString(),

                                    );
                                  },
                                  text:('Upload'),
                                  height: 4.h,
                                  width: 8.w,
                                  textColor: Colors.white,
                                  radius: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );

  }
   Future<void> sendNotification(String title, String message) async {
    ActionProvider.startLoading();
     const String appId = 'f8d63d16-4294-4e67-8dc6-32ce553af11f';
     const String restApiKey = 'OWQzOTQ4MzItZDdmZC00YTk2LWI2MGEtNWRmMjY1OGFkOTE4';

     try {
       final response = await http.post(
         Uri.parse('https://onesignal.com/api/v1/notifications'),
         headers: {
           'Content-Type': 'application/json; charset=UTF-8',
           'Authorization': 'Basic $restApiKey',
         },
         body: jsonEncode({
           'app_id': appId,
           'included_segments': ['All'],
           'headings': {'en': title},
           'contents': {'en': message},
         }),
       );
       ActionProvider.stopLoading();

       if (response.statusCode == 200) {
         log('Notification sent successfully!');
         await saveNotificationToFirestore(title, message,isSent: true);
       } else {
         await saveNotificationToFirestore(title, message, isSent: false);
         log('Failed to send notification. Status code: ${response.statusCode}');
         log('Response: ${response.body}');
         // Additional error handling can go here, such as showing a message to the user
       }
     } catch (e) {

       log('Error occurred while sending notification: $e');
       // Handle specific errors if needed
     }
   }

   Future<void> saveNotificationToFirestore(String title, String message,{bool isSent = true}) async {
     try {
       var id = FirebaseFirestore.instance.collection('notifications').doc().id;
       CollectionReference notifications = FirebaseFirestore.instance.collection('notifications');
       await notifications.doc(id).set({
         'id':id,
         'title': title,
         'message': message,
         'description' : _descriptionController.isNull ? "" : _descriptionController.text.toString(),
         'timestamp': DateTime.now().microsecondsSinceEpoch.toString(),
         'status': isSent ? 'Sent' : 'Failed',

       });
       ActionProvider.stopLoading();

       log('Notification saved to Firestore successfully!');
     } catch (e) {
       ActionProvider.stopLoading();

       log('Failed to save notification to Firestore: $e');
       // Handle Firestore-specific errors if needed
     }
   }

  Consumer<DropdownProviderN> buildDropDown(BuildContext context, int index) {
    final List<String> Type = [
      'Email',
      'SMS',
      'Push Notification ',
    ];
    return Consumer<DropdownProviderN>(
      builder: (context, dropdownProvider, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 4.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: primaryColor,
                        width: 1.0,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        dropdownProvider
                            .closeOtherDropdowns(index); // Close other dropdowns
                        dropdownProvider.toggleDropdownVisibility(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AppTextWidget(
                              text: dropdownProvider.selectedType,
                              color: primaryColor,
                            ),
                            Icon(
                              dropdownProvider.isDropdownVisible(index)
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down_rounded,
                              color: primaryColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (dropdownProvider.isDropdownVisible(index))
              Positioned(
                top: 8.8.h,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: primaryColor,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: Type.map((Type) {
                      return GestureDetector(
                        onTap: () {
                          dropdownProvider.setSelectedLanguage(Type);
                          dropdownProvider.toggleDropdownVisibility(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 5.0),
                          child: AppTextWidget(
                            text: Type,
                            fontSize: 10,
                            textAlign: TextAlign.start,
                            softWrap: false,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

}
