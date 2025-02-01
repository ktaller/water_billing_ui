import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_billing_ui/constants/constants.dart';

import 'form_controller.dart';

class FormPage extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FormController _formController = FormController();

  FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _formController.responseCustomWidget(
                  'form',
                  'firstName',
                  'First Name',
                ),
                SizedBox(height: 16),
                _formController.responseCustomWidget(
                  'form',
                  'lastName',
                  'Last Name',
                ),
                SizedBox(height: 16),
                _formController.responseCustomWidget(
                  'phoneNumber',
                  'phoneNumber',
                  'Phone Number',
                ),
                SizedBox(height: 16),
                _formController.responseCustomWidget(
                  'email',
                  'email',
                  'Email',
                ),
                SizedBox(height: 16),
                _formController.responseCustomWidget(
                  'description',
                  'address',
                  'Address',
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      _submitForm(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Error: Please fill all required fields')),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    final formData = _formKey.currentState?.value;

    log("Form Data: $formData");

    final requestJson = {
      "firstName": formData!['firstName'].toString().trim(),
      "lastName": formData['lastName'].toString().trim(),
      "phoneNumber": formData['phoneNumber'].toString().trim().substring(4),
      "email": formData['email'].toString().trim(),
      "address": formData['address'].toString().trim()
    };

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(Constants.PREFERENCE_JWT_TOKEN);

      final url =
          Uri.parse('${Constants.SERVER_BASE_URL_API}/customers/create');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(requestJson),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Customer data submitted successfully')));
        log("Success: Customer data submitted successfully");
      } else {
        log('Error: ${response.statusCode}: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      log('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
