import '../tracker/trackerModel.dart';


class Admin {
  final String name;
  final String email;

  Admin({
    required this.name,
    required this.email,

  });
  factory Admin.fromMap(Map<String, dynamic> data) {
    return Admin(
      name: data['name'] ?? '',
      email: data['email'] ?? '',

    );
  }
}


class User {
   String? accountType;
   String? age;
   String? avatar;
   String? birthDate;
   String? child;
   String? createdAt;
   String? dietPlan;
   String? email;
   String? feedingFormula;
   String? imageUrl;
   String? isPolicyAccept;
   List<String>? moods;
   String? name;
   String? password;
   String? pregnant;
   String? singletonSection;
   String? sleepHour;
   String? status;
   String? stressLevel;
   String? subscriptionPlan;
   String? trialStartDate;
   String? uid;
   String? vaginalBirth;
   final List<Tracker> trackers; // Add the List of trackers to the User model


   User({
     this.accountType,
     this.age,
     this.avatar,
     this.birthDate,
     this.child,
     this.createdAt,
     this.dietPlan,
     this.email,
     this.feedingFormula,
     this.imageUrl,
     this.isPolicyAccept,
     this.moods,
     this.name,
     this.password,
     this.pregnant,
     this.singletonSection,
     this.sleepHour,
     this.status,
     this.stressLevel,
     this.subscriptionPlan,
     this.trialStartDate,
     this.uid,
     this.vaginalBirth,
      this.trackers = const [], // Initialize trackers
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      accountType: data['accountType'] ?? '',
      age: data['age'] ?? '',
      avatar: data['avatar'] ?? '',
      birthDate: data['birthDate'] ?? '',
      child: data['child'] ?? '',
      createdAt: data['createdAt'] ?? '',
      dietPlan: data['dietPlan'] ?? '',
      email: data['email'] ?? '',
      feedingFormula: data['feedingFormula'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isPolicyAccept: data['isPolicyAccept'] ?? '',
      moods: List<String>.from(data['moods'] ?? []),
      name: data['name'] ?? '',
      password: data['password'] ?? '',
      pregnant: data['pregnant'] ?? '',
      singletonSection: data['singletonSection'] ?? '',
      sleepHour: data['sleepHour'] ?? '',
      status: data['status'] ?? '',
      stressLevel: data['stressLevel'] ?? '',
      subscriptionPlan: data['subscriptionPlan'] ?? '',
      trialStartDate: data['trialStartDate'] ?? '',
      uid: data['uid'] ?? '',
      vaginalBirth: data['vaginalBirth'] ?? '',
    );
  }
}
// Tracker Model

class Tracker {
  String? sleetAt;
  String? type;
  String? messageNote;
  String? stressLevel;
  String? painLevel;
  String? categoryId;
  String? image;
  String? days;
  String? id;
  String? moodName;
  String? intensity;
  String? wakeDuringNight;
  String? wakeUpAt;
  String? timeStamp;
  List<String>? options;
  List<dynamic>? causesList;
  List<TrackerQuestionModel>? questions;

  Tracker({
    this.sleetAt,
    this.type,
    this.messageNote,
    this.image,
    this.categoryId,
    this.days,
    this.painLevel,
    this.stressLevel,
    this.moodName,
    this.id,
    this.intensity,
    this.wakeDuringNight,
    this.wakeUpAt,
    this.options,
    this.timeStamp,
    this.questions,
    this.causesList,
  });

  factory Tracker.fromMap(Map<String, dynamic> data) {
    return Tracker(
      sleetAt: data['sleetAt'],
      type: data['type'],
      stressLevel: data['stressLevel'],
      image: data['image'],
      days: data['days'],
      painLevel: data['painLevel'],
      id: data['id'],
      intensity: data['intensity'],
      categoryId: data['categoryId'],
      messageNote: data['messageNote'],
      moodName: data['moodName'],
      wakeDuringNight: data['wakeDuringNight'],
      wakeUpAt: data['wakeUpAt'],
      timeStamp: data['timeStamp'],
      causesList: data['causesList'] ?? [],
      options: data['options'] != null ? List<String>.from(data['options']) : [],
      questions: (data['questions'] as List<dynamic>?)
          ?.map((question) => TrackerQuestionModel.fromMap(question))
          .toList() ?? [],
    );
  }
}


