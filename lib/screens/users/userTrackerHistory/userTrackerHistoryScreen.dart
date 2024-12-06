import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../constant.dart';
import '../../../controller/menu_App_Controller.dart';
import '../../../model/res/components/custom_appBar.dart';
import '../../../model/res/constant/app_assets.dart';
import '../../../model/res/widgets/app_text.dart.dart';
import '../../../provider/stream/streamProvider.dart';
import '../../../model/user_model/user_model.dart';

class UserTrackerHistoryScreen extends StatefulWidget {
  @override
  _UserTrackerHistoryScreenState createState() =>
      _UserTrackerHistoryScreenState();
}

class _UserTrackerHistoryScreenState extends State<UserTrackerHistoryScreen> {
  String? selectedMonth;

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
              SizedBox(
                width: 15.w,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffF7FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  hint: const Text("Select Month"),
                  value: selectedMonth,
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value!;
                    });
                  },
                  items: _getMonthOptions()
                      .map((month) => DropdownMenuItem<String>(
                    value: month,
                    child: Text(month),
                  ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              _buildTrackerView(type!),
              const SizedBox(height: 20),
              TrackerLodData(
                type: type,
                uid: uid,
                selectedMonth: selectedMonth,
              ),
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
      padding: EdgeInsets.symmetric(horizontal: 3.w), // Adjust the horizontal padding as needed
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: primaryColor),
        alignment: Alignment.center,
        child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}

List<String> _getMonthOptions() {
  return List.generate(12, (index) {
    DateTime month = DateTime(DateTime.now().year, index + 1);
    return DateFormat('MMMM yyyy').format(month);
  });
}

class TrackerLodData extends StatelessWidget {
  final String type;
  final String uid;
  final String? selectedMonth;

  TrackerLodData({
    required this.type,
    required this.uid,
    this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<StreamDataProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<List<Tracker>>(
          stream: provider.getTrackerLogs(type: type, uid: uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("loading..."));
            }
            if (snapshot.hasError) {
              return Center(child: SelectableText('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No log found'));
            }

            // Filter data by selected month
            List<Tracker> filteredTrackers =
            _filterTrackersByMonth(snapshot.data!, selectedMonth);

            if (filteredTrackers.isEmpty) {
              return const Center(child: Text('No data for selected month'));
            }

            return _buildTrackerList(
                context, filteredTrackers, type, uid);
          },
        );
      },
    );
  }

  List<Tracker> _filterTrackersByMonth(
      List<Tracker> trackers, String? selectedMonth) {
    if (selectedMonth == null) return trackers;

    return trackers.where((tracker) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
          int.parse(tracker.createdAt!));
      String trackerMonth = DateFormat('MMMM yyyy').format(date);
      return trackerMonth == selectedMonth;
    }).toList();
  }

  Widget _buildTrackerList(
      BuildContext context,
      List<Tracker> trackerList,
      String type,
      String userId
      ) {
    // Sort tracker list by date
    trackerList.sort((a, b) => int.parse(a.createdAt!).compareTo(int.parse(b.createdAt!)));

    // Track the weeks for which buttons have been shown
    Set<int> displayedWeeks = {};

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      itemCount: trackerList.length,
      itemBuilder: (ctx, index) {
        Tracker tracker = trackerList[index];
        DateTime weekDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(tracker.createdAt!),
        );

        // Calculate the week number
        int weekOfYear = _getWeekOfMonth(weekDate);

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    ],
                  ),
                ],
              ),
              // Show the button only once per week
              if (!displayedWeeks.contains(weekOfYear) && _isPastWeek(weekDate))
                InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    _showNoteDialog(context, userId, weekOfYear, tracker.createdAt);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    alignment: Alignment.centerRight,
                    child: AppTextWidget(
                      text: 'Add week $weekOfYear results',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      textDecoration: TextDecoration.underline,
                      underlinecolor: Colors.black,
                      color: primaryColor,
                    ),
                  ),
                ),
              SizedBox(height: 1.h),
            ],
          ),
        );
      },
    );
  }

// Helper to get the week number of the year
  // Helper to get the week number of the month
  int _getWeekOfMonth(DateTime date) {
    // Get the first day of the month
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

    // Calculate the difference in days from the first day of the month to the given date
    int dayOfMonth = date.day;

    // Calculate the week number (1-based index)
    return ((dayOfMonth + firstDayOfMonth.weekday - 1) / 7).ceil();
  }


// Helper to check if the date is in the past week
  bool _isPastWeek(DateTime date) {
    return DateTime.now().difference(date).inDays >= 7;
  }


  void _showNoteDialog(
      BuildContext context, String userId, int weekOfYear, timeStamp) {
    TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add Note"),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(hintText: "Enter your note here"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String note = noteController.text.trim();
                if (note.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(userId)
                      .collection("notes")
                      .doc(timeStamp)
                      .set({
                    'week': weekOfYear,
                    'createdAt': timeStamp,
                    'note': note,
                  }, SetOptions(merge: true));
                  Navigator.pop(ctx);
                }
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
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

  Widget _buildContentCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h), // Adjust padding as needed
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  // int _getWeekOfMonth(DateTime date) {
  //   final firstDayOfMonth = DateTime(date.year, date.month, 1);
  //   final offset = (firstDayOfMonth.weekday - 1) % 7;
  //   return ((date.day + offset) / 7).ceil();
  // }

