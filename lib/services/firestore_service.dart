import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/study_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<StudyModel>> getStudies(String uid) {
    return _db
        .collection('studies')
        .doc(uid)
        .collection('userStudies')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudyModel.fromFirestore(doc))
            .toList());
  }

  Future<void> saveStudy(String uid, StudyModel study) {
    return _db
        .collection('studies')
        .doc(uid)
        .collection('userStudies')
        .add(study.toMap());
  }

  Future<void> deleteStudy(String uid, String studyId) {
    return _db
        .collection('studies')
        .doc(uid)
        .collection('userStudies')
        .doc(studyId)
        .delete();
  }
}
