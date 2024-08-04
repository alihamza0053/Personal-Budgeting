import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_budgeting/main_screen.dart';

void main() async {
  //firebase initializing
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyC692YBmbhvXuTpdLLKSB-FzRea4dGBkCo',
          appId: '1:382664905208:android:026d593b4c87e6cf57060d',
          messagingSenderId: '382664905208',
          projectId: 'personal-budgeting-ba817'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Budgeting App",
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.black,foregroundColor: Colors.white)),
      home: MainScreen(),
    );
  }
}
