import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_billing_ui/constants/constants.dart';

class AddMeterPage extends StatefulWidget {
  final int customerId;

  const AddMeterPage({super.key, required this.customerId});

  @override
  State<AddMeterPage> createState() => _AddMeterPageState();
}

class _AddMeterPageState extends State<AddMeterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _meterNumberController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  String? _meterStatus = 'Active';
  String? _meterType = 'Domestic';
  bool _isActive = false;

  final Map<String, int> _meterTypeMap = {
    // Map string values to integers
    'Domestic': 1,
    'Commercial': 2,
    'Industrial': 3,
  };

  final Map<String, int> _meterStatusMap = {
    'Active': 1,
    'Inactive': 2,
    'Suspended': 3
  };

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final meterNumber = _meterNumberController.text;
      final latitude = double.tryParse(_latitudeController.text);
      final longitude = double.tryParse(_longitudeController.text);

      // Prepare meter data for the API request
      final meterData = {
        "meterNumber": meterNumber,
        "customer": widget.customerId,
        "locationLat": latitude,
        "locationLng": longitude,
        "status": _meterStatusMap[_meterStatus],
        "meterType": _meterTypeMap[_meterType],
        "isActive": _isActive,
      };

      log("Meter Data: $meterData");

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Meter Details'),
          content: Text(
            'Meter Number: $meterNumber\n'
            'Latitude: $latitude\n'
            'Longitude: $longitude\n'
            'Status: ${_meterStatusMap[_meterStatus]}\n'
            'Type: ${_meterTypeMap[_meterType]}\n'
            'Is Active: $_isActive',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString(Constants.PREFERENCE_JWT_TOKEN);

                Navigator.of(context).pop(); // Close the dialog

                // Send POST request to create meter on server
                final url =
                    Uri.parse('${Constants.SERVER_BASE_URL_API}/meters/create');
                final response = await http.post(
                  url,
                  headers: {
                    'Authorization': 'Bearer $token',
                    'Content-Type': 'application/json'
                  },
                  body: jsonEncode(meterData),
                );

                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Meter added successfully!')),
                  );
                  // Clear the form after successful submission (optional)
                  _formKey.currentState!.reset();
                  log('Meter added successfully!');
                  Navigator.pop(context);
                } else {
                  log('Error: ${response.statusCode}: ${response.body}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${response.body}')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _meterNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Meter Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the meter number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _latitudeController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the latitude.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _longitudeController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Longitude',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the longitude.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _meterStatus,
                  decoration: const InputDecoration(
                    labelText: 'Meter Status',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Active', 'Inactive', 'Suspended']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _meterStatus = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the meter status.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _meterType,
                  decoration: const InputDecoration(
                    labelText: 'Meter Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Domestic', 'Commercial', 'Industrial']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _meterType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the meter type.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Is Active'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
