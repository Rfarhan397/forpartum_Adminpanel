import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart'; // For responsive sizing
import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../model/res/widgets/button_widget.dart';
import '../../provider/action/action_provider.dart';
import '../../provider/dropDOwn/dropdown.dart';
import '../../provider/libraryCard/card_provider.dart';
import '../../provider/user_provider/user_provider.dart';

class InsightScreen extends StatelessWidget {
  InsightScreen({super.key});

  final TextEditingController _answerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> categories = [
    'Hair and skin',
    'Hot flashes',
    'Breast',
    'Cardiovascular',
    'Uterus',
    'Abdominal wall',
    'Fluids',
    'GI Rectal',
    'Shivering',
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final drop = Provider.of<DropdownProviderN>(context);
    final action = Provider.of<ActionProvider>(context);
    final faqProvider = Provider.of<FaqProvider>(context);
    final dataP = Provider.of<MenuAppController>(context);

    final users = userProvider.users;
    final activeUsersCount = users.where((user) => user.status == 'isActive').length;
    final totalUsersCount = users.length;

    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    final newSignupsCount = users.where((user) {
      final createdAtTimestampString = user.createdAt;
      if (createdAtTimestampString != null) {
        final createdAtTimestamp = int.tryParse(createdAtTimestampString);
        if (createdAtTimestamp != null) {
          final createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtTimestamp);
          return createdAt.month == currentMonth && createdAt.year == currentYear;
        }
      }
      return false;
    }).length;

    return Scaffold(
      appBar: CustomAppbar(text: 'Insights Overview'),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              _buildInsightsForm(context, drop, action, dataP),
              SizedBox(height: 2.h),
              _buildInsightsList(context, dataP, faqProvider, drop, action),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the form for adding and editing insights.
  Widget _buildInsightsForm(BuildContext context, DropdownProviderN drop, ActionProvider action, MenuAppController dataP) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget(text: 'Insights:', fontSize: 22, fontWeight: FontWeight.w500),
        SizedBox(height: 2.h),
        AppTextWidget(text: 'Type:', fontWeight: FontWeight.w500, fontSize: 16),
        SizedBox(height: 1.h),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: primaryColor),
          ),
          child: DropdownButton<String>(
            underline: const SizedBox.shrink(),
            style: const TextStyle(color: Colors.black),
            dropdownColor: Colors.white,
            value: drop.selectedInsightCategory,
            onChanged: (String? newValue) {
              if (newValue != null) {
                drop.setSelectedInsightsCategory(newValue);
              }
            },
            items: categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            icon: const Icon(Icons.keyboard_arrow_down_outlined, color: primaryColor),
          ),
        ),
        SizedBox(height: 1.h),
        AppTextWidget(text: 'Description:', fontWeight: FontWeight.w500, fontSize: 16),
        SizedBox(height: 1.h),
        Container(
          width: 35.w,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IntrinsicHeight(
            child: TextField(
              maxLines: null,
              expands: true,
              controller: _answerController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(12.0),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Consumer<ActionProvider>(
          builder: (context, value, child) {
            return Align(
              alignment: Alignment.centerRight,
              child: ButtonWidget(
                text: value.publishText,
                oneColor: true,
                onClicked: () async {
                  if (value.editingId == null) {
                    await _publishInsight(context, dataP.parameters!.uid.toString());
                  } else {
                    _updateInsight(context, dataP.parameters!.uid.toString());
                  }
                },
                width: 100,
                height: 35,
                fontWeight: FontWeight.normal,
              ),
            );
          },
        ),
      ],
    );
  }

  /// Build the list of insights fetched from Firebase.
  Widget _buildInsightsList(BuildContext context, MenuAppController dataP, FaqProvider faqProvider, DropdownProviderN drop, ActionProvider action) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget(
          text: "${dataP.parameters!.name}'s Insights:",
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 2.h),
        Divider(height: 1.0, color: Colors.grey.shade300),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(dataP.parameters!.uid)
              .collection('insights')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No insights found'));
            }

            var data = snapshot.data!.docs;
            faqProvider.initializeExpandedList(data.length);

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                var document = data[index];
                return _buildInsightItem(context, document, index, faqProvider, drop, action, dataP);
              },
            );
          },
        ),
      ],
    );
  }

  /// Build an individual insight item in the list.
  Widget _buildInsightItem(BuildContext context, QueryDocumentSnapshot document, int index, FaqProvider faqProvider, DropdownProviderN drop, ActionProvider action, MenuAppController dataP) {
    final isExpanded = faqProvider.expanded[index];
    final question = document['question'];
    final answer = document['answer'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => faqProvider.toggleExpandd(index),
          child: ListTile(
            title: AppTextWidget(text: question, fontSize: 14,textAlign: TextAlign.start,),
            trailing: const Icon(Icons.keyboard_arrow_down_outlined, size: 15),
          ),
        ),
        if (isExpanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: AppTextWidget(text: answer, fontSize: 14, maxLines: 30,textAlign: TextAlign.start,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: secondaryColor),
                    onPressed: () {
                      drop.setSelectedInsightsCategory(document['question']);
                      _answerController.text = document['answer'];
                      action.setEditingMode(document.id);
                      action.scrollToTextField(_scrollController);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: primaryColor),
                    onPressed: () async {
                      bool confirmDelete = await action.showDeleteConfirmationDialog(context, 'Delete!', 'Are you sure you want to delete?');
                      if (confirmDelete) {
                        deleteItem(dataP.parameters!.uid.toString(), document.id);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        Divider(height: 1.0, color: Colors.grey.shade300),
      ],
    );
  }

  /// Delete an insight from Firebase.
  void deleteItem(String uid, String id) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('insights')
        .doc(id)
        .delete();
  }

  /// Publish a new insight to Firebase.
  Future<void> _publishInsight(BuildContext context, String uid) async {
    final drop = Provider.of<DropdownProviderN>(context, listen: false);
    if (drop.selectedInsightCategory == null || _answerController.text.isEmpty) {
      AppUtils().showToast(text: 'Please fill in all fields');
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('insights')
        .add({
      'question': drop.selectedInsightCategory!,
      'answer': _answerController.text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _answerController.clear();
   // drop.clearSelectedCategory();
    AppUtils().showToast(text: 'Insight added successfully');
  }

  /// Update an existing insight in Firebase.
  void _updateInsight(BuildContext context, String uid) {
    final action = Provider.of<ActionProvider>(context, listen: false);
    final drop = Provider.of<DropdownProviderN>(context, listen: false);

    if (action.editingId == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('insights')
        .doc(action.editingId)
        .update({
      'question': drop.selectedInsightCategory!,
      'answer': _answerController.text,
    });

   // action.setEditingMode();
    _answerController.clear();
   // drop.clearSelectedCategory();
    AppUtils().showToast(text:'Insight updated successfully');
  }
}
