import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_billing_ui/constants/constants.dart';

class MeterReadingFormPage extends StatefulWidget {
  final String meterNumber; // Receive meter number as argument

  const MeterReadingFormPage({required this.meterNumber, super.key});

  @override
  State<MeterReadingFormPage> createState() => _MeterReadingFormPageState();
}

class _MeterReadingFormPageState extends State<MeterReadingFormPage> {
  final TextEditingController _readingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _submitReading() async {
    if (_formKey.currentState!.validate()) {
      final reading = double.parse(_readingController.text);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Reading'),
          content: Text('Submit the reading: $reading m³?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();

                setState(() {
                  _isLoading = true;
                });

                try {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String? token =
                      prefs.getString(Constants.PREFERENCE_JWT_TOKEN);

                  final url = Uri.parse(
                      '${Constants.SERVER_BASE_URL_API}/meter-readings/create');
                  final meterReadingData = {
                    "meterNumber": widget.meterNumber,
                    "currentReading": reading,
                  };

                  final response = await http.post(
                    url,
                    headers: {
                      'Authorization': 'Bearer $token',
                      'Content-Type': 'application/json'
                    },
                    body: jsonEncode(meterReadingData),
                  );

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Reading submitted successfully!')),
                    );
                    _readingController.clear();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Error: ${response.statusCode} - ${response.body}')),
                    );
                    log('Error: ${response.statusCode}: ${response.body}');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                  log('Error: $e');
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      );
    }
  }

  void _navigateBackToCustomerList() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meter Reading Form'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _readingController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Meter Reading',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a reading.';
                          }
                          try {
                            double.parse(value); // Try parsing to double
                          } catch (e) {
                            return 'Enter a valid number.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 200.0,
                        child: ElevatedButton(
                          onPressed: _submitReading,
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _navigateBackToCustomerList,
                        child: const Text('Back to List'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
