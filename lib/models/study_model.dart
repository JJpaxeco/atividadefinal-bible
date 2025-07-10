import 'package:cloud_firestore/cloud_firestore.dart';

class StudyModel {
  final String? id;
  final String verse;
  final String studyText;
  final Timestamp createdAt;

  StudyModel({
    this.id,
    required this.verse,
    required this.studyText,
    required this.createdAt,
  });

  factory StudyModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return StudyModel(
      id: doc.id,
      verse: data['verse'],
      studyText: data['studyText'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'verse': verse,
      'studyText': studyText,
      'createdAt': createdAt,
    };
  }
}
