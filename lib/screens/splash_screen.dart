import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_billing_ui/constants/constants.dart';
import 'package:water_billing_ui/screens/landing_page.dart';
import 'package:water_billing_ui/screens/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  set firstName(firstName) {}

  get firstName => firstName;

  set lastName(lastName) {}

  get lastName => lastName;

  Future<Widget> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3)); // Minimum 2-second delay

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(Constants.PREFERENCE_JWT_TOKEN);

    log("Splash App Token: $token");

    if (token != null) {
      bool isValid = await _verifyToken(token);
      if (isValid) {
        return LandingPage();
      } else {
        await prefs.remove(Constants.PREFERENCE_JWT_TOKEN);
        return LoginPage();
      }
    } else {
      return LoginPage();
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

      log("Splash Response ${response.statusCode}: ${response.body}");

      if (response.statusCode == 200) {
        firstName = jsonDecode(response.body)['firstName'];
        lastName = jsonDecode(response.body)['lastName'];
        // TODO: Refresh the token everytime the user logs in to avoid expiry if they uses the app more frequently
        return true;
      } else {
        // Token is invalid or expired or not returned
        log("Token invalid or expired: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log('Error verifying token: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show splash screen while waiting
          return _buildSplashScreenContent(); // Call your splash screen UI builder
        } else if (snapshot.hasError) {
          log("Error during initialization: ${snapshot.error}");
          return _buildSplashScreenContent();
        } else {
          return snapshot.data!;
        }
      },
    );
  }

  Widget _buildSplashScreenContent() {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.lightBlueAccent], // Gradient blue
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const Spacer(), // Push content to the center
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                FaIcon(
                  FontAwesomeIcons.water, // Water icon from Font Awesome
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  'Water Billing',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Spacer(), // Push footer to the bottom
            const Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Text(
                'Simplified billing',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
