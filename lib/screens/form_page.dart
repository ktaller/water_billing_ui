import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'form_controller.dart';

class FormPage extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FormController _formController = FormController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _formController.responseCustomWidget(
                'form',
                'firstname',
                'First Name',
              ),
              SizedBox(height: 16),
              _formController.responseCustomWidget(
                'form',
                'lastname',
                'Last Name',
              ),
              SizedBox(height: 16),
              _formController.responseCustomWidget(
                'phoneNumber',
                'phone',
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
                    final formData = _formKey.currentState?.value;
                    Get.snackbar('Form Submitted', formData.toString());
                  } else {
                    Get.snackbar('Error', 'Please fill all required fields');
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
