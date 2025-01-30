import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent, // App bar color
      ),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Two horizontal cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildReportCard(
                      icon: FontAwesomeIcons.chartBar,
                      title: 'Total Monthly Consumption',
                    ),
                  ),
                  const SizedBox(width: 16), // Spacing between cards
                  Expanded(
                    child: _buildReportCard(
                      icon: FontAwesomeIcons.moneyBillWave,
                      title: 'Expected Income',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Spacing between rows

              // Single card below (same width as above)
              Row(
                children: [
                  Expanded(
                    child: _buildReportCard(
                      icon: FontAwesomeIcons.tint,
                      title: 'Leakage',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Report Card Widget
  Widget _buildReportCard({required IconData icon, required String title}) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: SizedBox(
        height: 120, // Fixed height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
