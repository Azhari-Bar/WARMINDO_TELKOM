import 'package:flutter/material.dart';
import 'login_screen.dart'; // Pastikan path ini benar
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // File yang dibuat otomatis oleh Firebase CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warmindo Online',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color.fromARGB(255, 14, 151, 18), // Warna latar khas Warmindo
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: const Color.fromARGB(255, 13, 14, 13), fontSize: 16),
          bodyMedium: const TextStyle(color: Colors.black),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}


