import 'package:flutter/material.dart';
import 'package:water_billing_ui/screens/form_page.dart';
import 'registration_page.dart'; // Import the registration page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FormPage(), // Show the RegistrationPage when the app starts
    );
  }
}
