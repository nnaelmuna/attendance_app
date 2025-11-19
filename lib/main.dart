import 'package:attendance_app/wrapper/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ini harus di representasikan di main.dart => google-services.
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyATbCpFtSacQo8bVclo5uiCELUCGoqnFDU",
      appId: "1:39386372643:android:ca169861ed2776ec01af96",
      messagingSenderId: "39386372643",
      projectId: "attendance-app-39ca8",
    ),
  );
  runApp(AttendanceApp());
}


class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
        )
      ),
      home: AuthWrapper(),
    );
  }
}
