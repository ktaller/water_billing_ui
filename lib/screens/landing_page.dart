import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'customers_list.dart';
import 'reports_pages/reports_page.dart'; // Import the Reports page (Create this later)

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Simple Billing',
      //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32,color: Colors.white),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.indigoAccent, // App bar color
      // ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigoAccent, Colors.lightBlueAccent], // Gradient blue
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Water Drop Icon
              Padding(
                padding: const EdgeInsets.all(48.0),
                child: const FaIcon(
                  FontAwesomeIcons.handHoldingDroplet , // Water Drop Icon
                  size: 100,
                  color: Colors.white,
                ),
              ),
              const Spacer(), // to push content downward

              // Welcome Text
              const Text(
                'Welcome to Simple Billing!\nEasily manage your water billing with customer tracking and reporting.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 50), // Spacing

              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCard(
                    icon: FontAwesomeIcons.user,
                    title: 'Customers List',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CustomersPage()),
                      );
                    },
                  ),
                  _buildCard(
                    icon: FontAwesomeIcons.chartColumn,
                    title: 'Reports',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReportsPage()),
                      );
                    },
                  ),
                ],
              ),

              const Spacer(), // Push footer content upwards
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 7,
        child: SizedBox(
          width: 140,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
