import 'package:flutter/material.dart';
import 'package:water_billing_ui/screens/user_registration.dart';

import 'meters_page.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _customers = [
    {'name': 'John Doe', 'phone': '+254700123456'},
    {'name': 'Jane Smith', 'phone': '+254700654321'},
    {'name': 'Michael Brown', 'phone': '+254700789123'},
    {'name': 'John Doe', 'phone': '+254700123456'},
    {'name': 'Jane Smith', 'phone': '+254700654321'},
    {'name': 'Michael Brown', 'phone': '+254700789123'},
    {'name': 'John Doe', 'phone': '+254700123456'},
    {'name': 'Jane Smith', 'phone': '+254700654321'},
    {'name': 'Michael Brown', 'phone': '+254700789123'},
    {'name': 'John Doe', 'phone': '+254700123456'},
    {'name': 'Jane Smith', 'phone': '+254700654321'},
    {'name': 'Michael Brown', 'phone': '+254700789123'},
  ];

  List<Map<String, String>> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _filteredCustomers = _customers;
    _searchController.addListener(_filterCustomers);
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
                      MaterialPageRoute(builder: (context) => const MetersPage()),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the RegistrationPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
