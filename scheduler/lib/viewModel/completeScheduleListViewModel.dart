import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/completeSchedule.dart';

final completeScheduleListProvider =
    Provider((_) => CompleteScheduleListViewModel());

class CompleteScheduleListViewModel with ChangeNotifier {
  List<CompleteSchedule> completeSchedules = [];
  QueryDocumentSnapshot<Map<String, dynamic>>? userCompleteDocument;

  Future<bool> fetchScheduleFromFirestore(String? userEmail) async {
    completeSchedules = [];

    if (userEmail == null) {
      return false;
    }

    try {
      await initFirestoreDocument(userEmail);
    } catch (e) {
      userCompleteDocument = null;
      return false;
    }

    try {
      final userSnapshot = await userCompleteDocument!.reference
          .collection("completeSchedules")
          .get();

      for (var userSchedule in userSnapshot.docs) {
        final newCompleteSchedule = CompleteSchedule.of(
            userSchedule["id"],
            userSchedule["name"],
            userSchedule["motivate"],
            userSchedule["startTime"].toDate(),
            userSchedule["endTime"].toDate(),
            userSchedule["imagePath"]);
        insertScheduleToSchedules(newCompleteSchedule);
      }
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<void> initFirestoreDocument(String userEmail) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("users").get();
      userCompleteDocument =
          snapshot.docs.firstWhere((doc) => doc["mail"] == userEmail);
    } catch (e) {
      rethrow;
    }
  }

  bool addCompleteSchedule(CompleteSchedule schedule) {
    if (!insertScheduleToFirestore(schedule)) {
      return false;
    }

    insertScheduleToSchedules(schedule);
    return true;
  }

  bool insertScheduleToFirestore(CompleteSchedule schedule) {
    if (userCompleteDocument == null) {
      return false;
    }

    try {
      userCompleteDocument!.reference
          .collection("completeSchedules")
          .doc(schedule.id)
          .set({
        "id": schedule.id,
        "name": schedule.name,
        "motivate": schedule.motivation,
        "startTime": schedule.startDateTime,
        "endTime": schedule.endDateTime,
        "imagePath": schedule.imagePath,
      });
    } catch (e) {
      return false;
    }

    return true;
  }

  void insertScheduleToSchedules(CompleteSchedule schedule) {
    for (int i = 0; i < completeSchedules.length; i++) {
      if (completeSchedules[i].startDateTime.isAfter(schedule.startDateTime)) {
        completeSchedules.insert(i, schedule);
        notifyListeners();
        return;
      }
    }
    completeSchedules.add(schedule);
    notifyListeners();
  }
}
