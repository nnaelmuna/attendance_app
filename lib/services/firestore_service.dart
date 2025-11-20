import 'package:attendance_app/models/attendance_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get attendance records for a user (real-time stream)
  Stream<List<AttendanceRecord>> getAttendaceRecords(String userId) {
    return 'Hello Nael';
  }
}