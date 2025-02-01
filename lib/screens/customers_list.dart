import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Import FontAwesome for icons
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(Constants.PREFERENCE_JWT_TOKEN);

    final url = Uri.parse('${Constants.SERVER_BASE_URL_API}/customers');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

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

          log("Customers: $_customers");

          _filteredCustomers = _customers;
        });
      } else {
        log('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        log('Error fetching customers: $e');
      }
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
        title: const Text(
          'Customers List',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchCustomers,
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search customers...',
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
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.indigoAccent,
                              child: Icon(
                                Icons.person_outline_rounded,
                                color: Colors.white,
                              ),
                            ),
                            title: Row(
                              children: [
                                // const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(
                                  customer['name']!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                // const Icon(Icons.phone, size: 16, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(customer['phone']!),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MetersPage(
                                    customerId: int.parse(customer['id']!),
                                    customerName: customer['name']!,
                                  ),
                                ),
                              );
                            },
                          ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormPage()),
          );
        },
        label: const Text(
          'Add Customer',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
