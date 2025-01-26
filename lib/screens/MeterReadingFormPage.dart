import 'package:flutter/material.dart';

class MeterReadingFormPage extends StatefulWidget {
  const MeterReadingFormPage({super.key});

  @override
  State<MeterReadingFormPage> createState() => _MeterReadingFormPageState();
}

class _MeterReadingFormPageState extends State<MeterReadingFormPage> {
  final TextEditingController _readingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitReading() {
    if (_formKey.currentState!.validate()) {
      final reading = int.parse(_readingController.text);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Reading'),
          content: Text('Submit the reading: $reading m³?'),

          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform the submit action
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reading submitted successfully!')),
                );
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
        title: const Text('Meter Reading Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _readingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Meter Reading ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reading.';
                  }
                  final intValue = int.tryParse(value);
                  if (intValue == null || intValue <= 0) {
                    return 'Enter a valid positive number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitReading,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
