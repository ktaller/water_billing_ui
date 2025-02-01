import 'dart:convert';
import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_billing_ui/constants/constants.dart';

class MonthlyConsumptionReport extends StatefulWidget {
  const MonthlyConsumptionReport({super.key});

  @override
  State<MonthlyConsumptionReport> createState() =>
      _MonthlyConsumptionReportState();
}

class _MonthlyConsumptionReportState extends State<MonthlyConsumptionReport> {
  List<double> consumptionData = List.filled(12, 0); // Initialize with zeros
  double totalConsumption = 0;
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchConsumptionData();
  }

  Future<void> _fetchConsumptionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(Constants.PREFERENCE_JWT_TOKEN);

    log("Token: $token");

    final url = Uri.parse(
        '${Constants.SERVER_BASE_URL_API}/meter-readings/consumption-report');

    try {
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;

        setState(() {
          // Reset consumptionData to 0s
          consumptionData = List.filled(12, 0);

          for (var data in jsonData) {
            final month = data['month'] as int;
            final totalConsumptionForMonth = data['totalConsumption'] as double;
            if (month >= 1 && month <= 12) {
              // Check for valid month range
              consumptionData[month - 1] = totalConsumptionForMonth;
            }
          }
          totalConsumption = consumptionData.reduce((a, b) => a + b);
          isLoading = false;

          log('Consumption data: $consumptionData Total consumption: $totalConsumption');
        });
      } else {
        // Handle error
        log('Error fetching data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      log('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalConsumption = consumptionData.reduce((a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            style: TextStyle(color: Colors.white),
            'Monthly Consumption Report'),
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Consumption per Month",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "This chart represents the monthly water consumption in units. "
                      "Each bar represents the consumption for a given month. "
                      "Use this data to analyze trends and detect usage patterns.",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 40),

                    // Chart
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.55, // Chart takes 70% of screen height
                      child: BarChart(
                        BarChartData(
                          barGroups: _generateBarGroups(consumptionData),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  return Text('${value.toInt()}');
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      months[value.toInt()],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                },
                                reservedSize: 30,
                              ),
                            ),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            // Removes numbers on the right
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles:
                                        false)), // Removes numbers on top
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    // Space before total consumption statement

                    // Total Year's Consumption Report
                    Text(
                      "From the above chart, it is fair to conclude that: \nTotal yearly consumption: $totalConsumption units",
                      style: const TextStyle(
                        fontSize: 18,
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

  List<BarChartGroupData> _generateBarGroups(List<double> consumptionData) {
    return List.generate(consumptionData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: consumptionData[index],
            width: 20,
            // Thicker bars
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 150,
              color: Colors.grey[300],
            ),
          ),
        ],
      );
    });
  }
}

List<String> months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];
