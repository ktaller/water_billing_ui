import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_billing_ui/constants/constants.dart';

import 'add_meter_page.dart';
import 'meter_details_page.dart';

class MetersPage extends StatefulWidget {
  final String customerName;
  final int customerId;

  const MetersPage(
      {super.key, required this.customerName, required this.customerId});

  @override
  State<MetersPage> createState() => _MetersPageState();
}

class _MetersPageState extends State<MetersPage> {
  final List<Map<String, dynamic>> _meters = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchMeters();
  }

  Future<void> _fetchMeters() async {
    setState(() {
      _isLoading = true; // Set loading state
      _error = ''; // Clear any previous errors
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(Constants.PREFERENCE_JWT_TOKEN);

    final url = Uri.parse('${Constants.SERVER_BASE_URL_API}/meters/customer');

    try {
      // put an id to a JSON object
      final body = jsonEncode({'id': widget.customerId});
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          _meters.clear();
          _meters.addAll(decodedData.map((meter) {
            if (kDebugMode) {
              log('Meter: $meter');
            }
            return {
              'id': meter['id'],
              'meter_number': meter['meterNumber'],
            };
          }));
        });
      } else {
        setState(() {
          _error = 'Error: ${response.statusCode} - ${response.body}';
        });
        if (kDebugMode) {
          log('Error: ${response.statusCode} - ${response.body}');
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching meters: $e';
      });
      if (kDebugMode) {
        log('Error fetching meters: $e');
      }
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false after request is complete
      });
    }
  }

  String get customerName => widget.customerName;

  get cId => widget.customerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent, // Set background color to indigo
        title: Text(
          "$customerName's meters",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white, // Set text color to white
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _fetchMeters, // Pull-to-refresh functionality
        child: Column(
          children: [
            // List of meters
            Expanded(
              child: _meters.isNotEmpty
                  ? ListView.builder(
                      itemCount: _meters.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4, // Add elevation for a lifted effect
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Adjust spacing
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.water, color: Colors.blue),
                      title: Text(
                        "Meter Number " + _meters[index]['meter_number'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeterDetailsPage(
                              meterNumber: _meters[index]['meter_number'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },

              )
                  : _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: Text(
                            _error.isNotEmpty ? _error : 'No meters found',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
            ),
          ],
        ),
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to the AddMeterPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMeterPage(customerId: cId),
            ),
          );
        },
        label: const Text(
          'Add Meter',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white, // White text
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white), // White icon
        backgroundColor: Colors.indigo, // Indigo background
      ),

    );
  }
}
