import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/completeSchedule.dart';

class CompleteScheduleListViewModel with ChangeNotifier {
  List<CompleteSchedule> completeSchedules = [];
  QueryDocumentSnapshot<Map<String, dynamic>>? userCompleteDocument;
}
