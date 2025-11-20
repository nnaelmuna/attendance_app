import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class StorageServices {
 final FirebaseAuth _auth = FirebaseAuth.instance;
 final DatabaseReference _database = FirebaseDatabase.instanceFor(
  app: FirebaseDatabase.instance.app,
  // Ambil link dari firebase => Realtime Database
  databaseURL: 'https://attendance-app-39ca8-default-rtdb.asia-southeast1.firebasedatabase.app/',
 ).ref(); // menandakan ini sebuah reference

 // Upload photo to firebase realtime database as Base64 (String)
 Future<String> uploadAttendancePhoto(String localPath, String photoType) async {
  try {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final file = File(localPath);

    // Compress image to reduce size (IMPORTANT FOR REALTIME DATABASE)
    final compressBytes = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 800,
      minHeight: 600,
      quality: 70
    );

    if (compressBytes == null) {
      throw Exception('Failed to compress image');
    }

    // Convert to Base64
    final base64Image = base64Encode(compressBytes);

    // Create unique key
    final photoKey = '${DateTime.now().millisecondsSinceEpoch}_$photoType';

    // Save to realtime database
    await _database
        .child('attendance_photos')
        .child(user.uid)
        .child(photoKey)
        .set(
          {
          'data': base64Image,
          'timestamp': ServerValue.timestamp,
          'type': photoType
          }
        );

    // Return the key as reference 
    return photoKey;
  } catch (e) {
    throw Exception('Failed to upload photo: $e');
  }
 }

 // Get photo from firebase realtime database
 Future<String?> getPhotoBase64(String photoKey) async {
  try {
    final user = _auth.currentUser;
    if (user == null) return null;

    final snapshot = await _database
        .child('attendance_photos')
        .child(user.uid)
        .child(photoKey)
        .child('data')
        .get();

    if (snapshot.exists) {
      return snapshot.value as String;
    }

    return null;
  } catch (e) {
    return null;
  }
 }

 // Delete photo from firebase realtime database
 Future<void> deletePhoto(String photoKey) async {
  try {
    final user = _auth.currentUser;
    if (user == null) return;

    await _database
        .child('attendance_photos')
        .child(user.uid)
        .child(photoKey)
        .remove();
  } catch (e) {
    
  }
 }
}