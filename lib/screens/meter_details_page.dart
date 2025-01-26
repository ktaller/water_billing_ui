import 'package:flutter/material.dart';

import 'MeterReadingFormPage.dart';

class MeterDetailsPage extends StatefulWidget {
  const MeterDetailsPage({super.key});

  @override
  State<MeterDetailsPage> createState() => _MeterDetailsPageState();
}

class _MeterDetailsPageState extends State<MeterDetailsPage> {
  final List<Map<String, String>> _meterDetails = [
    {'date': '2025-01-26', 'reading': '1500 m3'},
    {'date': '2024-12-26', 'reading': '1450 m3'},
    {'date': '2024-11-26', 'reading': '1400 m3'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meter Details'),
      ),

      body: Column(
        children: [
          Expanded(
            child: _meterDetails.isNotEmpty
                ? ListView.builder(
              itemCount: _meterDetails.length,
              itemBuilder: (context, index) {
                final detail = _meterDetails[index];
                return ListTile(
                  title: Text(
                    detail['date']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('Reading: ${detail['reading']}'),
                );
              },
            )
                : const Center(
              child: Text(
                'No meter readings available.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add a new meter reading (placeholder action for now)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MeterReadingFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
