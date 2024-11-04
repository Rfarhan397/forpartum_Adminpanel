import 'package:cloud_firestore/cloud_firestore.dart';

class TrackerQuestionModel {
  String id;
  String text;
  String image;
  String type;
  List<TrackerOptionModel> optionModel;
  List<dynamic> allOptions;
  String? selectedOption;

  TrackerQuestionModel({
    required this.id,
    required this.text,
    required this.type,
    required this.image,
    required this.optionModel,
    required this.allOptions,
    required this.selectedOption,
  });

  factory TrackerQuestionModel.fromMap(Map<String, dynamic> data) {
    return TrackerQuestionModel(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
      image: data['image'] ?? '',
      type: data['type'] ?? '',
      selectedOption: data['selectedOption'] ?? '',
      allOptions: data['allOptions'] ?? [],
      optionModel: [],
    );
  }

  // Convert the instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'type': type,
    };
  }
}


class TrackerOptionModel {
  final String id;
  final String text;



  TrackerOptionModel({
    required this.id,
    required this.text,
  });


  factory TrackerOptionModel.fromMap(Map<String, dynamic> data) {
    return TrackerOptionModel(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }
}
class PainCategory {
  final String id;
  final String category;

  PainCategory({required this.id, required this.category});

  factory PainCategory.fromDocument(DocumentSnapshot doc) {
    return PainCategory(
      id: doc['Id'],
      category: doc['category'] as String,
    );
  }
}