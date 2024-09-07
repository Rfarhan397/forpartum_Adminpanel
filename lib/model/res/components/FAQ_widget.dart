import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../provider/libraryCard/card_provider.dart';
import '../widgets/app_text.dart.dart';

class FaqWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.w,
      child: Column(
        children: [
          SizedBox(height: 2.h,),
          Divider(
            height: 1.0,
            color: Colors.grey.shade300,
          ),
          StreamBuilder(
            stream:  FirebaseFirestore.instance.collection('faq').snapshots(),
            builder: (context, snapshot) {
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

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var document = snapshot.data!.docs[index];
                  var question = document['question'];  // Assuming 'privacy' is the field storing the policy
                  var answer = document['answer'];  // Assuming 'privacy' is the field storing the policy
                  return Consumer<FaqProvider>(
                    builder: (context, faqProvider, child) {
                      final isExpanded = faqProvider.expanded[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              faqProvider.toggleExpand(index);
                            },
                            child: ListTile(
                              title: AppTextWidget(
                                text: question,
                                textAlign: TextAlign.start,
                              ),
                              trailing: Icon(Icons.add,color: Color(0xff8C8C8C),size: 15,),
                            ),
                          ),
                          if (isExpanded)
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0,left: 16.0,bottom: 15.0),
                              child: AppTextWidget(
                                text: answer,
                                textAlign: TextAlign.start,
                                fontSize: 12,
                                color: Color(0xff585858),
                                maxLines: 30,
                              ),
                            ),
                          Container(
                            height: 1.0,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
