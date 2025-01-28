import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    final url = Uri.parse('${Constants.SERVER_BASE_URL_API}/meters/customer');

    try {
      // put an id to a JSON object
      final body = jsonEncode({'id': widget.customerId});
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          _meters.clear();
          _meters.addAll(decodedData.map((meter) {
            print('Meter: $meter');
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
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching meters: $e';
      });
      print('Error fetching meters: $e');
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
        // set customer name as the title
        title: Text(customerName),
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
                  return ListTile(
                    title: Text("Meter  #" + _meters[index]['meter_number']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MeterDetailsPage(
                                meterNumber: _meters[index]
                                ['meter_number'])),
                      );
                    },
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
            MaterialPageRoute(builder: (context) => AddMeterPage(customerId: cId)),
          );
        },
        label: const Text('Add Meter'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
