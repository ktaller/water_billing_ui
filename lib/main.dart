import 'package:flutter/material.dart';
import 'registration_page.dart'; // Import the registration page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegistrationPage(), // Show the RegistrationPage when the app starts
    );
  }
}
