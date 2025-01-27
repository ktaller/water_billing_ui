import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:water_billing_ui/constants/constants.dart';

import 'meter_reading_form_page.dart';

class MeterDetailsPage extends StatefulWidget {
  final String meterNumber;

  const MeterDetailsPage({required this.meterNumber, Key? key})
      : super(key: key);

  @override
  State<MeterDetailsPage> createState() => _MeterDetailsPageState();
}

class _MeterDetailsPageState extends State<MeterDetailsPage> {
  List<Map<String, dynamic>> _meterDetails = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchMeterReadings();
  }

  Future<void> _fetchMeterReadings() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final url = Uri.parse(
          '${Constants.SERVER_BASE_URL_API}/meter-readings/get-by-meter');
      final body = jsonEncode({"meterNumber": widget.meterNumber});
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          _meterDetails = decodedData.map((reading) {
            DateTime dateTime = DateTime.parse(reading['createdAt']);
            double readingValue =
                reading['currentReading'] - reading["previousReading"];
            return {
              'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
              'reading': readingValue.toStringAsFixed(3),
            };
          }).toList();
        });
      } else {
        setState(() {
          _error = 'Error: ${response.statusCode} - ${response.body}';
        });
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching meter readings: $e';
      });
      print('Error fetching meter readings: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String get mNumber => widget.meterNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mNumber),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _meterDetails.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: _fetchMeterReadings,
                      child: ListView.builder(
                        itemCount: _meterDetails.length,
                        itemBuilder: (context, index) {
                          final detail = _meterDetails[index];
                          return ListTile(
                            title: Text(
                              detail['date'] ?? 'N/A', // Null check
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                'Reading: ${detail['reading'] ?? 'N/A'}'), // Null check
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'No meter readings available.',
                            style: TextStyle(fontSize: 16),
                          ),
                          ElevatedButton(
                            onPressed: _fetchMeterReadings,
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MeterReadingFormPage(meterNumber: widget.meterNumber),
            ),
          );
        },
        label: const Text('Add Meter-Reading'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
