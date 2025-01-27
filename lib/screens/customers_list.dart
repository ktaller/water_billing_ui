import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:water_billing_ui/constants/constants.dart';
import 'package:water_billing_ui/screens/user_registration.dart';

import 'meters_page.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _customers = [];

  List<Map<String, String>> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCustomers);
    _fetchCustomers();
  }

  // FIXME: refresh the data onResume()
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchCustomers();
  }

  void _fetchCustomers() async {
    // Replace with your actual API URL
    final url = Uri.parse('${Constants.SERVER_BASE_URL_API}/customers');

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body) as List;
        setState(() {
          _customers.clear();
          _customers.addAll(decodedData.map((customer) {
            return {
              'id': customer['id'].toString(),
              'name': customer['firstName'] + ' ' + customer["lastName"],
              'phone': customer['phoneNumber'],
            };
          }));

          print("Customers: $_customers");

          _filteredCustomers = _customers; // Update filtered list as well
        });
      } else {
        // Handle API errors
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Handle network errors
      print('Error fetching customers: $e');
    }
  }

  void _filterCustomers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCustomers = _customers
          .where((customer) =>
              customer['name']!.toLowerCase().contains(query) ||
              customer['phone']!.contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers List'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          // List of customers
          Expanded(
            child: _filteredCustomers.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = _filteredCustomers[index];
                      return ListTile(
                        title: Text(customer['name']!),
                        subtitle: Text(customer['phone']!),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                // builder: (context) => const MetersPage()),
                                // pass the customer ID and name to the MetersPage
                                builder: (context) => MetersPage(
                                      customerId: int.parse(customer['id']!),
                                      customerName: customer['name']!,
                                    )),
                          );
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No customers found',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to the RegistrationPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormPage()),
          );
        },
        label: const Text('Add Customer'), // Add text label
        icon: const Icon(Icons.add), // Add the icon
      ),
    );
  }
}
