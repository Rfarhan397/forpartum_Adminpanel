import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/constant.dart';
import 'package:forpartum_adminpanel/main.dart';
import 'package:forpartum_adminpanel/model/res/components/custom_appBar.dart';
import 'package:forpartum_adminpanel/model/res/constant/app_assets.dart';
import 'package:forpartum_adminpanel/model/res/widgets/app_text.dart.dart';
import 'package:forpartum_adminpanel/model/user_model/user_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/menu_App_Controller.dart';
import '../../../model/res/constant/app_colors.dart';
import '../../../provider/stream/streamProvider.dart';
import '../user_detail.dart';

class UserTrackerHistoryScreen extends StatelessWidget {
  const UserTrackerHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataP = Provider.of<MenuAppController>(context);
    // Retrieve the trackers and type values
    final type = dataP.type;
    final parameters = dataP.parameters;

    return Scaffold(
      appBar: const CustomAppbar(
        text: 'Tracker History',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Divider(
              height: 1,
              color: customGrey,
            ),
            SizedBox(height: 1.h,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget(
                  text: '$type Tracker History',
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 20),

                /// Table header row
                if (type == 'sleep') _sleepView(),
                if (type == 'mood') _moodView(),
                if (type == 'pain') _painView(),
                if (type == 'stress') _stressView(),
                if (type == 'energy') _energyView(),
                const SizedBox(height: 10),

                /// Table content rows with vertical padding

                if (type == 'sleep')
                  // sleepViewDetails(dataP),
                  TrackerLodData(
                    type: "sleep",
                    uid: dataP.parameters!.uid!,
                  ),
                if (type == 'mood')
                  TrackerLodData(
                    type: "mood",
                    uid: dataP.parameters!.uid!,
                  ),
                  if (type == 'pain')
                    TrackerLodData(
                      type: "pain",
                      uid: dataP.parameters!.uid!,
                    ),
                    if (type == 'stress')
                      TrackerLodData(
                        type: "stress",
                        uid: dataP.parameters!.uid!,
                      ),
                      if (type == 'energy')
                        TrackerLodData(
                          type: "energy",
                          uid: dataP.parameters!.uid!,
                        ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget sleepViewDetails(MenuAppController parameterP) {
  //   log("List Data:: ${parameterP.parameters!.trackers}");
  //   if (parameterP.parameters == null || parameterP.parameters!.trackers.isEmpty) {
  //     return Center(child: Text('No sleep data ss.'));
  //   }
  //
  //   return Expanded(
  //     child: ListView.builder(
  //       itemCount: parameterP.parameters!.trackers.length,
  //       itemBuilder: (context, index) {
  //         final tracker = parameterP.parameters!.trackers[index];
  //         return Column(
  //           children: [
  //             Table(
  //               columnWidths: const {
  //                 0: FlexColumnWidth(1),
  //                 1: FlexColumnWidth(1),
  //                 2: FlexColumnWidth(1),
  //                 3: FlexColumnWidth(1),
  //               },
  //               children: [
  //                 TableRow(
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(8),
  //                     border: Border.all(color: customGrey),
  //                     color: Colors.white,
  //                   ),
  //                   children: [
  //                     _buildContentCell(tracker.timeStamp ?? ""), // Replace with actual property
  //                     _buildContentCell(tracker.sleetAt?? ""), // Replace with actual property
  //                     _buildContentCell(tracker.wakeUpAt?? ""), // Replace with actual property
  //                     _buildContentCell(tracker.wakeDuringNight?? ""), // Replace with actual property
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 1.h), // Vertical space after each row
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }
  //
  //
  // Widget stressViewDetails() {
  //   return Column(
  //           children: List.generate(10, (index) {
  //             return Column(
  //               children: [
  //                 Table(
  //                   columnWidths: const {
  //                     0: FlexColumnWidth(1),
  //                     1: FlexColumnWidth(1),
  //                     2: FlexColumnWidth(1),
  //                     3: FlexColumnWidth(1),
  //                   },
  //                   children: [
  //                     TableRow(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(8),
  //                         border: Border.all(color: customGrey),
  //                         color: Colors.white,
  //                       ),
  //                       children: [
  //                         _buildContentCell('20-2-2023'),
  //                         _buildContentCell('11:00 PM'),
  //                         _buildContentCell('6:00 AM'),
  //                         _buildContentCell('3 Times'),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 1.h), // Vertical space after each row
  //               ],
  //             );
  //           }),
  //         );
  // }
  // Widget painViewDetails() {
  //   return Column(
  //           children: List.generate(10, (index) {
  //             return Column(
  //               children: [
  //                 Table(
  //                   columnWidths: const {
  //                     0: FlexColumnWidth(1),
  //                     1: FlexColumnWidth(1),
  //                     2: FlexColumnWidth(1),
  //                     3: FlexColumnWidth(1),
  //                   },
  //                   children: [
  //                     TableRow(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(8),
  //                         border: Border.all(color: customGrey),
  //                         color: Colors.white,
  //                       ),
  //                       children: [
  //                         _buildContentCell('20-2-2023'),
  //                         _buildContentCell('11:00 PM'),
  //                         _buildContentCell('6:00 AM'),
  //                         _buildContentCell('3 Times'),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 1.h), // Vertical space after each row
  //               ],
  //             );
  //           }),
  //         );
  // }
  // Widget energyViewDetails() {
  //   return Column(
  //           children: List.generate(10, (index) {
  //             return Column(
  //               children: [
  //                 Table(
  //                   columnWidths: const {
  //                     0: FlexColumnWidth(1),
  //                     1: FlexColumnWidth(1),
  //                     2: FlexColumnWidth(1),
  //                     3: FlexColumnWidth(1),
  //                   },
  //                   children: [
  //                     TableRow(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(8),
  //                         border: Border.all(color: customGrey),
  //                         color: Colors.white,
  //                       ),
  //                       children: [
  //                         _buildContentCell('20-2-2023'),
  //                         _buildContentCell('11:00 PM'),
  //                         _buildContentCell('6:00 AM'),
  //                         _buildContentCell('3 Times'),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 1.h), // Vertical space after each row
  //               ],
  //             );
  //           }),
  //         );
  // }

  /// Method to create header cells
  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: primaryColor,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }


  Widget _stressView() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      border: TableBorder.all(
        color: Colors.transparent,
        width: 2,
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.transparent,
              style: BorderStyle.none,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: _buildHeaderCell('Date'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildHeaderCell('Stress level'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildHeaderCell('Stress causing'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildHeaderCell('Note'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _moodView() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      border: TableBorder.all(
        color: Colors.transparent,
        width: 2,
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.transparent,
              style: BorderStyle.none,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: _buildHeaderCell('Date'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildHeaderCell('Mood Emotion'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: _buildHeaderCell('Note'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sleepView() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      border: TableBorder.all(
        color: Colors.transparent,
        width: 2,
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.transparent,
              style: BorderStyle.none,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: _buildHeaderCell('Date'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildHeaderCell('Sleep At'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildHeaderCell('Wake Up At'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildHeaderCell('Num of Wake Up at Night'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _painView() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
      },
      border: TableBorder.all(
        color: Colors.transparent,
        width: 2,
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.transparent,
              style: BorderStyle.none,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildHeaderCell('Date'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildHeaderCell('Pain'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildHeaderCell('Troubling Issue'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildHeaderCell('Pain Duration'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildHeaderCell('Pain Level'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _energyView() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
      },
      border: TableBorder.all(
        color: Colors.transparent,
        width: 2,
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.transparent,
              style: BorderStyle.none,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: _buildHeaderCell('Date'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: _buildHeaderCell('Energy Level'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: _buildHeaderCell(' Meal Today'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: _buildHeaderCell('Rested Today'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: _buildHeaderCell('Time Spend Passion'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: _buildHeaderCell('Note'),
            ),
          ],
        ),
      ],
    );
  }
}

class TrackerLodData extends StatelessWidget {
  final String type, uid;
  int? limit;
  TrackerLodData(
      {super.key, required this.type, this.limit, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Consumer<StreamDataProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<List<Tracker>>(
          stream: provider.getTrackerLogs(limit: limit, type: type, uid: uid),
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

            List<Tracker> trackerList = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              itemCount: trackerList.length,
              itemBuilder: (ctx, index) {
                Tracker tracker = trackerList[index];
                return type == 'sleep'
                    ? Column(
                        children: [
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(1),
                              3: FlexColumnWidth(1),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: customGrey),
                                  color: Colors.white,
                                ),
                                children: [
                                  _buildContentCell(formatTimestamp(tracker.timeStamp.toString()) ??
                                      ""), // Replace with actual property
                                  _buildContentCell(tracker.sleetAt ??
                                      ""), // Replace with actual property
                                  _buildContentCell(tracker.wakeUpAt ??
                                      ""), // Replace with actual property
                                  _buildContentCell(tracker.wakeDuringNight ??
                                      ""), // Replace with actual property
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                              height: 1.h), // Vertical space after each row
                        ],
                      )
                    : type == 'mood'
                        ? Column(
                            children: [
                              Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: customGrey),
                                      color: Colors.white,
                                    ),
                                    children: [
                                      _buildContentCell(formatTimestamp(tracker.timeStamp.toString())??
                                          "date"), // Replace with actual property
                                      _buildContentCellImage(tracker.image ??
                                          "image"), // Replace with actual property
                                      _buildContentCell(tracker.messageNote ??
                                          "message"), // Replace with actual property
                                     ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 1.h), // Vertical space after each row
                            ],
                          )
                        : type == 'pain'
                            ? Column(
                                children: [
                                  Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(1),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(1),
                                      3: FlexColumnWidth(1),
                                      4: FlexColumnWidth(1),
                                    },
                                    children: [
                                      TableRow(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(color: customGrey),
                                          color: Colors.white,
                                        ),
                                        children: [
                                          _buildContentCell(formatTimestamp(tracker.timeStamp.toString())??
                                              "N/A"), // Replace with actual property
                                          _buildContentCell(tracker.intensity??
                                              "N/A"), // Replace with actual property
                                          _buildContentCell(tracker.causesList?[0].toString() ??
                                              "N/A"), // Replace with actual property
                                          _buildContentCell("${tracker.days} days" ??
                                              "N/A"),
                                          _buildContentCell(tracker
                                                  .painLevel ??
                                              "N/A"), // Replace with actual property
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          1.h), // Vertical space after each row
                                ],
                              )
                            : type == 'stress'
                                ? Column(
                                    children: [
                                      Table(
                                        columnWidths: const {
                                          0: FlexColumnWidth(1),
                                          1: FlexColumnWidth(1),
                                          2: FlexColumnWidth(1),
                                          3: FlexColumnWidth(1),
                                        },
                                        children: [
                                          TableRow(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border:
                                                  Border.all(color: customGrey),
                                              color: Colors.white,
                                            ),
                                            children: [
                                              _buildContentCell(formatTimestamp(tracker.timeStamp.toString())??
                                                  ""), // Replace with actual property
                                              _buildContentCell(tracker
                                                      .stressLevel ??
                                                  ""), // Replace with actual property
                                              _buildContentCell(tracker
                                                      .causesList?[0] ??
                                                  ""), // Replace with actual property
                                              _buildContentCell(tracker
                                                      .messageNote ??
                                                  ""), // Replace with actual property
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: 1
                                              .h), // Vertical space after each row
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Table(
                                        columnWidths: const {
                                          0: FlexColumnWidth(1),
                                          1: FlexColumnWidth(1),
                                          2: FlexColumnWidth(1),
                                          3: FlexColumnWidth(1),
                                        },
                                        children: [
                                          TableRow(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border:
                                                  Border.all(color: customGrey),
                                              color: Colors.white,
                                            ),
                                            children: [
                                              _buildContentCell(formatTimestamp(tracker.timeStamp.toString()) ??
                                                  ""), // Replace with actual property
                                              _buildContentCell(tracker
                                                      .questions?[0].allOptions[0] ??
                                                  ""), // Replace with actual property
                                              _buildContentCell(tracker
                                                      .questions?[1].allOptions[0] ??
                                                  ""), // Replace with actual property
                                              _buildContentCell(tracker
                                                      .questions?[0].allOptions[0] ??
                                                  ""), /// Replace with actual property
                                              _buildContentCell(tracker
                                                      .questions?[0].allOptions[0] ??
                                                  ""), /// Replace with actual property
                                              _buildContentCell(tracker
                                                      .messageNote ??
                                                  ""), // Replace with actual property
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: 1
                                              .h), // Vertical space after each row
                                    ],
                                  );
              },
            );
          },
        );
      },
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

  Widget _buildContentCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
  Widget _buildContentCellImage(String image) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      alignment: Alignment.center,
      child: image.isNotEmpty? Image.network(
        image,
        width: 40,
        height: 40,
      ):Image.asset(AppAssets.person)
    );
  }

  String convertTimestampToDate(int timestamp) {
    // Convert timestamp from milliseconds to DateTime object
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Format the date to 'MM-dd-yyyy'
    final DateFormat formatter = DateFormat('MM-dd-yyyy');
    return formatter.format(date);
  }
}
