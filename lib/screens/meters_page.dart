import 'package:flutter/material.dart';

import 'meter_details_page.dart';

class MetersPage extends StatefulWidget {
  const MetersPage({super.key});

  @override
  State<MetersPage> createState() => _MetersPageState();
}

class _MetersPageState extends State<MetersPage> {
  final List<String> _meters = [
    'Meter #12345',
    'Meter #67890',
    'Meter #11223',
    'Meter #12345',
    'Meter #67890',
    'Meter #11223',
    'Meter #12345',
    'Meter #67890',
    'Meter #11223',
    'Meter #12345',
    'Meter #67890',
    'Meter #11223',
    'Meter #12345',
    'Meter #67890',
    'Meter #11223',
    'Meter #12345',
    'Meter #67890',
    'Meter #11223',
    'Meter #12345',
    'Meter #67890',
    'Meter #11223',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Meters'),
      ),
      body: Column(
        children: [
          // List of meters
          Expanded(
            child: _meters.isNotEmpty
                ? ListView.builder(
              itemCount: _meters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    '${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: Text(_meters[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MeterDetailsPage()),
                    );
                  },
                );

              },
            )
                : const Center(
              child: Text(
                'No meters found',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add a new meter (placeholder action for now)
          setState(() {
            _meters.add('Meter #${_meters.length + 12345}');
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
