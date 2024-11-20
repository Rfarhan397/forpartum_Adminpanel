import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/widgets/app_text.dart.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../constant.dart';
import '../../model/res/components/custom_appBar.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(text: 'Feedbacks'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            SizedBox(height: 2.h,),
            Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('feedbacks').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No feedbacks found'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var document = snapshot.data!.docs[index];
                        var name = document['name'];
                        var email = document['email'];
                        var feedbacks = List<String>.from(document['feedbacks']);
                        var timestamp = int.tryParse(document['timestamp']) ?? 0;
                        var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
                        var formattedDate = DateFormat('dd-MM-yyyy').format(date);

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                      const AppTextWidget(text: 'Date:' ,fontWeight: FontWeight.w500,fontSize: 18,textAlign: TextAlign.start,),
                                        SizedBox(width: 2.w,),
                                        AppTextWidget(text:
                                          formattedDate,
                                            fontSize: 14,
                                            color: Colors.black,
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.feedback, color: primaryColor),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const AppTextWidget(text: 'Name:' ,fontWeight: FontWeight.w500,fontSize: 18,textAlign: TextAlign.start,),
                                    SizedBox(width: 2.w,),
                                    AppTextWidget(text:
                                      name,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const AppTextWidget(text: 'E-mail:' ,fontWeight: FontWeight.w500,fontSize: 18,textAlign: TextAlign.start,),
                                    SizedBox(width: 2.w,),
                                    AppTextWidget(text:
                                    email,
                                        fontSize: 14,
                                        color: Colors.grey,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const AppTextWidget(text: 'Feedbacks:' ,fontWeight: FontWeight.w500,fontSize: 18,textAlign: TextAlign.start,),
                                    SizedBox(width: 2.w,),
                                    Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: feedbacks.map((feedback) {
                                        return Chip(
                                          side: const BorderSide(
                                            color: Colors.transparent
                                          ),
                                          label: Text(feedback,style: const TextStyle(color: Colors.white),),
                                          backgroundColor: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
