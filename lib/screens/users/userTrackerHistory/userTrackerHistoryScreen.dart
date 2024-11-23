import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/widgets/app_text_field.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../constant.dart';
import '../../../controller/menu_App_Controller.dart';
import '../../../model/res/components/custom_appBar.dart';
import '../../../model/res/constant/app_assets.dart';
import '../../../model/res/widgets/app_text.dart.dart';
import '../../../model/user_model/user_model.dart';
import '../../../provider/stream/streamProvider.dart';

class UserTrackerHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataP = Provider.of<MenuAppController>(context);
    final type = dataP.type;
    final uid = dataP.parameters?.uid ?? '';

    return Scaffold(
      appBar: const CustomAppbar(text: 'Tracker History'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 1, color: customGrey),
              SizedBox(height: 1.h),
              AppTextWidget(
                text: '$type Tracker History',
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 20),
              _buildTrackerView(type!),
              const SizedBox(height: 10),
              TrackerLodData(type: type, uid: uid),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTrackerView(String type) {
    final headerTitles = _getHeaderTitles(type);
    if (headerTitles.isEmpty) return Container();

    return Table(
      columnWidths: {
        for (int i = 0; i < headerTitles.length; i++) i: const FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.transparent, width: 2),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Colors.transparent),
          children: headerTitles.map((title) => _buildHeaderCell(title)).toList(),
        ),
      ],
    );
  }


  List<String> _getHeaderTitles(String type) {
    switch (type) {
      case 'sleep':
        return ['Date', 'Sleep At', 'Wake Up At', 'Num of Wake Up at Night'];
      case 'mood':
        return ['Date', 'Mood Emotion', 'Mood Title', 'Note'];
      case 'pain':
        return ['Date', 'Pain', 'Troubling Issue', 'Pain Duration', 'Pain Level'];
      case 'stress':
        return ['Date', 'Stress Level', 'Stress Causing', 'Note'];
      case 'energy':
        return ['Date', 'Energy Level', 'Meal Today', 'Rested Today', 'Time Spent Passion', 'Note'];
      default:
        return [];
    }
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 3.w), // Adjust the horizontal padding as needed
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: primaryColor),
        alignment: Alignment.center,
        child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}

class TrackerLodData extends StatelessWidget {
  final String type;
  final String uid;
  final int? limit;

  TrackerLodData({required this.type, required this.uid, this.limit});

  @override
  Widget build(BuildContext context) {
    return Consumer<StreamDataProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<List<Tracker>>(
          stream: provider.getTrackerLogs(type: type, uid: uid, limit: limit),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("loading..."));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No log found'));
            }

            return _buildTrackerList(context,snapshot.data!, type,uid,);
          },
        );
      },
    );
  }

  Widget _buildTrackerList(context ,List<Tracker> trackerList, String type,userId,) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      itemCount: trackerList.length,
      itemBuilder: (ctx, index) {
        Tracker tracker = trackerList[index];
        DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(tracker.createdAt!));
        bool showIcon = DateTime.now().difference(date).inDays < 7;
        return Column(
          children: [
            Table(
              columnWidths: {
                for (int i = 0; i < _getColumnCount(type); i++) i: const FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: customGrey),
                    color: Colors.white,
                  ),
                  children: [
                    ..._buildContentCells(tracker, type),

                  ],                ),
              ],
            ),
            if (showIcon)
              InkWell(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _showNoteDialog(context,userId,tracker.timeStamp);
                },
                child: Container(
                  margin: EdgeInsets.all(4),
                  alignment: Alignment.centerRight,
                  child: AppTextWidget(text: 'Add results',fontWeight: FontWeight.w500,fontSize: 16,textDecoration: TextDecoration.underline,underlinecolor: Colors.black,color: primaryColor,) // Customize icon as needed
                ),
              ),
            SizedBox(height: 1.h),
          ],
        );
      },
    );
  }
  // Method to show the dialog with a text field and save button
  // Future<void> _showDialog(BuildContext context,userID) async {
  //   TextEditingController textController = TextEditingController();
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Enter Details"),
  //         content: AppTextField(
  //           hintText: 'Result',
  //           controller: textController,
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               // Save the text to Firestore
  //               _saveToFirestore(textController.text,userID);
  //               Navigator.pop(context); // Close the dialog
  //             },
  //             child: Text("Save"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Close the dialog
  //             },
  //             child: Text("Cancel"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  Future<void> _showNoteDialog(BuildContext context, String userID,timestamp) async {
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismissal
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5, // Adaptive width
            height: MediaQuery.of(context).size.height * 0.6, // Adaptive height
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget(text:
                  "Add Note",
                  fontSize: 20, fontWeight: FontWeight.bold),
                SizedBox(height: 16),
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: textController,
                        maxLines: null, // Allows multiline input
                        decoration: InputDecoration(
                          hintText: "Enter your note here...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _saveToFirestore(textController.text, userID,timestamp); // Save to Firestore
                        Navigator.pop(context);
                      },
                      child: Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveToFirestore(String text, userId,timestamp) async {
    if (text.isNotEmpty) {
      try {
        var id = FirebaseFirestore.instance.collection('users').doc(userId).collection('trackerResult').doc().id;
        FirebaseFirestore.instance.collection('users').doc(userId).collection('trackerResult').doc(timestamp).set({
          'type': type,
          'text': text,
          'timestamp': timestamp,
        });

        // Optionally, you can confirm the save by fetching the document after it's been added
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(userId).collection('trackerResult').doc(timestamp).get();
        if (doc.exists) {
          log("Data saved successfully: ${doc.data()}");
        } else {
          log("Data not found in Firestore.");
        }
      } catch (e) {
        log("Error saving text to Firestore: $e");
      }
    } else {
      log("Text input is empty, nothing to save.");
    }
  }
  int _getColumnCount(String type) {
    switch (type) {
      case 'sleep':
        return 4;
      case 'mood':
        return 4;
      case 'pain':
        return 5;
      case 'stress':
        return 4;
      case 'energy':
        return 6;
      default:
        return 0;
    }
  }

  List<Widget> _buildContentCells(Tracker tracker, String type) {
    switch (type) {
      case 'sleep':
        return [
          _buildContentCell(formatTimestamp(tracker.createdAt!)),
          _buildContentCell(tracker.sleetAt ?? 'N/A'),
          _buildContentCell(tracker.wakeUpAt ?? 'N/A'),
          _buildContentCell(tracker.wakeDuringNight ?? 'N/A'),
        ];
      case 'mood':
        return [
          _buildContentCell(formatTimestamp(tracker.createdAt!)),
          _buildContentCellImage(tracker.image ?? ''),
          _buildContentCell(tracker.moodName ?? 'N/A'),
          _buildContentCell(tracker.messageNote ?? 'N/A'),
        ];
      case 'pain':
        return [
          _buildContentCell(formatTimestamp(tracker.createdAt!)),
          _buildContentCell(tracker.intensity ?? 'N/A'),
          _buildContentCell(tracker.causesList?.first ?? 'N/A'),
          _buildContentCell('${tracker.days} days'),
          _buildContentCell(tracker.painLevel ?? 'N/A'),
        ];
      case 'stress':
        return [
          _buildContentCell(formatTimestamp(tracker.createdAt!)),
          _buildContentCell(tracker.stressLevel ?? 'N/A'),
          _buildContentCell(tracker.causesList?.first ?? 'N/A'),
          _buildContentCell(tracker.messageNote ?? 'N/A'),
        ];
      case 'energy':
        return [
          _buildContentCell(formatTimestamp(tracker.createdAt!)),
          _buildContentCell(tracker.questions?[0].allOptions[0] ?? 'N/A'),
          _buildContentCell(tracker.questions?[1].allOptions[0] ?? 'N/A'),
          _buildContentCell(tracker.questions?[2].allOptions[0] ?? 'N/A'),
          _buildContentCell(tracker.questions?[3].allOptions[0] ?? 'N/A'),
          _buildContentCell(tracker.messageNote ?? 'N/A'),
        ];
      default:
        return [];
    }
  }

  Widget _buildContentCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
      alignment: Alignment.center,
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildContentCellImage(String image) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      alignment: Alignment.center,
      child: image.isNotEmpty
          ? Image.network(image, width: 40, height: 40)
          : Image.asset(AppAssets.person),
    );
  }

  String formatTimestamp(String timestamp) {
    if (timestamp.isNotEmpty) {
      int milliseconds = int.parse(timestamp);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      // Format the date (you can customize the format as per your needs)
      return DateFormat('dd-MM-yyyy').format(date);
    }
    return 'N/A';
  }
}
