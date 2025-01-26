import 'package:flutter/material.dart';
import 'package:water_billing_ui/screens/customers_list.dart';

void main() {
  runApp(const MyApp());
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
      home: CustomersPage(), // Set CustomersPage as the initial page
    );
  }
}
