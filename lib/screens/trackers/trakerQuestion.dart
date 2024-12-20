import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/provider/tracker/trackerProvider.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';
import '../../model/res/components/custom_dropDown.dart';
import '../../model/res/constant/app_utils.dart';
import '../../model/tracker/trackerModel.dart';
import '../../provider/stream/streamProvider.dart';

class QuestionListSection extends StatelessWidget {
  final String type;
  final VoidCallback onTap;
  // TextEditingController? controller = TextEditingController();
  QuestionListSection({super.key, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final streamP = Provider.of<StreamDataProvider>(context, listen: false);
    final trackerP = Provider.of<TrackerProvider>(context, listen: false);

    return StreamBuilder<List<TrackerQuestionModel>>(
      stream: streamP.getTrackerLog(type: type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No $type questions found'));
        }

        List<TrackerQuestionModel> questionList = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          itemCount: questionList.length,
          itemBuilder: (ctx, index) {
            final question = questionList[index];

            return QuestionWidget(
              onTap: () {
                trackerP.controller.text = question.text;
                log("Length : ${question.optionModel[index].text}");
                trackerP.optionControllers.clear();
                for (int i = 0; i < question.optionModel.length; i++) {
                  trackerP.addController(
                      question.optionModel[i].id, question.id);
                  trackerP.optionControllers[i].text =
                      question.optionModel[i].text;
                }
                log("Options Id: ${trackerP.optionsId}");
              },
              type: type,
              question: question.text,
              options: question.optionModel,
              onOptionSelected: (selectedOption) {},
              deleteOnTap: () {
                _deleteCategory(context, question.id);

              },
            );
          },
        );
      },
    );
  }
  void _deleteCategory(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete!'),
        content: const Text('Are you sure you want to delete?'),
        actions: [
          TextButton(
            onPressed: () {
              _deleteCategoryFromFirestore(context, id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteCategoryFromFirestore(BuildContext context, String id) {
    FirebaseFirestore.instance
        .collection('trackerLog')
        .doc(id)
        .delete()
        .then((value) {
      AppUtils().showToast(text: 'Deleted successfully');
    })
        .catchError((error) {
      AppUtils().showToast(text: 'Error deleting');
    });
  }
}

class QuestionWidget extends StatelessWidget {
  final String question;
  final String type;
  final List<TrackerOptionModel> options;
  final Function(String) onOptionSelected;
  final VoidCallback onTap,deleteOnTap;

  const QuestionWidget({
    Key? key,
    required this.question,
    required this.options,
    required this.type,
    required this.onOptionSelected,
    required this.onTap,
    required this.deleteOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(question,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
             // Row(
             //   children: [
             //     InkWell(onTap: onTap, child: Icon(Icons.edit)),
             //     SizedBox(width: 0.6.w,),
             //     InkWell(onTap: deleteOnTap, child: Icon(Icons.delete)),
             //   ],
             // )
              PopupExample(
                onEdit: onTap,
                onDelete: deleteOnTap,
              )

            ],
          ),
          const SizedBox(height: 8),
          // Horizontal scrollable list for options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: options.map((option) {
                return GestureDetector(
                  onTap: () {
                    onOptionSelected(option.text);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.5.w, horizontal: 1.w),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10.w),
                        border: Border.all(width: 4.0, color: secondaryColor)),
                    child: Text(
                      option.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

}

class TrackerCausesList extends StatelessWidget {
  final String type;
  const TrackerCausesList({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final trackerP = Provider.of<TrackerProvider>(context, listen: false);
    final streamP = Provider.of<StreamDataProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: streamP.getStressOptionsStream(type: type),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No options available."));
              }

              final options = snapshot.data!.docs;

              // Use ValueListenableBuilder to listen to changes in the selectedOptionsNotifier
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2.w,
                    crossAxisSpacing: 2.w,
                    childAspectRatio: type == "mood" ? 0.9 : 1.0),
                itemCount: options.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final optionText = option['text'];
                  final intensity = option['intensity'];
                  final image = option['image'];
                  final id = option['id'];

                  return GestureDetector(
                    onTap: () {
                      // if(provider.selectedOptionsNotifier != optionText){
                      //   provider.clearSelectedOptions();
                      //   provider.selectOptionNotifier(optionText);
                      //   provider.selectedOptionImageNotifier.value = image;
                      // }
                    },
                    child: type == "stress"
                        ? _stressView(optionText)
                        : _moodView(
                      () {
                        //delete on TAp
                      _deleteCategory(context, id);
                      },
                            optionText,
                            image,
                            onTap: () {
                              trackerP.update();
                              trackerP.updateImage(image);
                              trackerP.controller.text = optionText;
                              trackerP.moodController.text = intensity;
                              trackerP.moodID = id;
                              log("length of $optionText");
                              trackerP.optionControllers.clear();
                            },
                          ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );

  }
  void _deleteCategory(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete!'),
        content: const Text('Are you sure you want to delete?'),
        actions: [
          TextButton(
            onPressed: () {
              _deleteCategoryFromFirestore(context, id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteCategoryFromFirestore(BuildContext context, String id) {
    FirebaseFirestore.instance
        .collection('trackerLog')
        .doc(id)
        .delete()
        .then((value) {
      AppUtils().showToast(text: 'Deleted successfully');
    })
        .catchError((error) {
      AppUtils().showToast(text: 'Error deleting');
    });
  }
  _stressView(optionText) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: lightPurpleColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          optionText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _moodView(VoidCallback? deleteOnTap,optionText, image, {VoidCallback? onTap} ) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(2.w),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: Offset(0, 2.w),
              blurRadius: 1.w,
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            child: Image.network(
              image,
              fit: BoxFit.cover,
              // height: 7.w
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                optionText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 0.5.w,
              ),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: onTap,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 0.5.w,
              ),
              InkWell(
                  onTap: deleteOnTap,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
