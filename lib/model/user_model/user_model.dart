// class User {
//   final String id;
//   final String name;
//   final String email;
//   final String isActive;
//   final String imageUrl;
//
//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.isActive,
//     required this.imageUrl,
//   });
//   factory User.fromMap(Map<String, dynamic> data) {
//     return User(
//       name: data['name'] ?? '',
//       email: data['email'] ?? '',
//       id: data['id'] ?? '',
//       isActive: data['isActive'] ?? '',
//       imageUrl: data['imageUrl'] ?? '',
//
//     );
//   }
// }
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
