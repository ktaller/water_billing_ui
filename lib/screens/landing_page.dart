import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_billing_ui/constants/constants.dart';
import 'package:water_billing_ui/screens/login_page.dart';

import 'customers_list.dart';
import 'reports_pages/reports_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String? firstName;
  String? lastName;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(Constants.PREFERENCE_JWT_TOKEN);

    if (token != null) {
      bool isValid = await _verifyToken(token);
      if (isValid) {
        await _getUserDetails(token);
      } else {
        log("Token invalid or expired");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }
  }

  Future<bool> _verifyToken(String token) async {
    final url = Uri.parse('${Constants.SERVER_BASE_URL_API}/auth/ping');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        log('Token verification failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Error verifying token: $e');
      return false;
    }
  }

  Future<void> _getUserDetails(String token) async {
    final url = Uri.parse('${Constants.SERVER_BASE_URL_API}/auth/ping');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        setState(() {
          firstName = userData['firstName'];
          lastName = userData['lastName'];
        });
      } else {
        log("Error getting user details: ${response.statusCode}");
      }
    } catch (e) {
      log("Error getting user details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Add an AppBar
        title: const Text(
          'Simple Billing',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white), // Reduced font size
        ),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout(context); // Call the logout function
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigoAccent, Colors.lightBlueAccent],
            // Gradient blue
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Water Drop Icon
              Padding(
                padding: const EdgeInsets.all(48.0),
                child: const FaIcon(
                  FontAwesomeIcons.handHoldingDroplet, // Water Drop Icon
                  size: 100,
                  color: Colors.white,
                ),
              ),
              const Spacer(), // to push content downward

              // Welcome Text
              Text(
                'Welcome to Simple Billing, ${firstName?[0]}.$lastName!\nEasily manage your water billing with customer tracking and reporting.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 50), // Spacing

              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCard(
                    icon: FontAwesomeIcons.user,
                    title: 'Customers List',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CustomersPage()),
                      );
                    },
                  ),
                  _buildCard(
                    icon: FontAwesomeIcons.chartColumn,
                    title: 'Reports',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReportsPage()),
                      );
                    },
                  ),
                ],
              ),

              const Spacer(), // Push footer content upwards
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.PREFERENCE_JWT_TOKEN);

    log("Logged out");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Widget _buildCard(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 7,
        child: SizedBox(
          width: 140,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
