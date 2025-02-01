import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_billing_ui/constants/constants.dart';

class ExpectedIncomeReport extends StatefulWidget {
  const ExpectedIncomeReport({super.key});

  @override
  State<ExpectedIncomeReport> createState() => _ExpectedIncomeReportState();
}

class _ExpectedIncomeReportState extends State<ExpectedIncomeReport> {
  List<double> incomeData = List.filled(12, 0); // Initialize with zeros
  double totalIncome = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchIncomeData();
  }

  Future<void> _fetchIncomeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(Constants.PREFERENCE_JWT_TOKEN);

    final year = DateTime.now().year; // Or get the year from user input
    final url = Uri.parse(
        '${Constants.SERVER_BASE_URL_API}/meter-readings/revenue-report');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'year': year}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;

        setState(() {
          incomeData = List.filled(12, 0); // Reset to zeros

          for (var data in jsonData) {
            final month = data['month'] as int;
            final income =
                data['totalAmount'] as double; // Use totalAmount from your DTO

            if (month >= 1 && month <= 12) {
              incomeData[month - 1] = income;
            }
          }

          totalIncome = incomeData.reduce((a, b) => a + b);
          isLoading = false;
        });
      } else {
        print(
            'Error fetching data: ${response.statusCode}, ${response.body}'); // Log the error
        setState(() {
          isLoading = false;
        });
        // Show a snackBar with the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error fetching income data: ${response.body}")),
        );
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred while fetching data.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // double totalIncome =
    //     incomeData.reduce((a, b) => a + b); // Calculate total expected income

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expected Income Report',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Expected Income per Month",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "This chart represents the expected income from water sales each month. "
                      "Each bar shows the estimated revenue for a given month. \n"
                      "Use this data to forecast cash flow and financial planning.",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 40),

                    // Chart Container
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.55, // 70% screen height
                      child: BarChart(
                        BarChartData(
                          barGroups: _generateBarGroups(incomeData),
                          minY: 30000,
                          // Start y-axis at 30,000
                          maxY: incomeData.reduce((a, b) => a > b ? a : b) +
                              20000,
                          // Set a reasonable max y-value
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 60,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  if (value < 30000)
                                    return const SizedBox(); // Hide values below 30,000
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text("Ksh ${value.toInt()}"),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 7.0),
                                    child: Text(
                                      months[value.toInt()],
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                },
                                reservedSize: 20,
                              ),
                            ),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            // Remove right numbers
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: false)), // Remove top numbers
                          ),
                          borderData: FlBorderData(show: false),
                          gridData:
                              FlGridData(show: true, drawVerticalLine: false),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30), // Spacing before total income

                    // Total Expected Income
                    Text(
                      // display 2 decimal places in money and separate by comma
                      "From the above chart, it is fair to conclude- \nTotal expected income this year: Ksh.${totalIncome.toStringAsFixed(2).replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},',
                          )}",
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

  List<BarChartGroupData> _generateBarGroups(List<double> incomeData) {
    return List.generate(incomeData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: incomeData[index],
            width: 20,
            color: Colors.greenAccent.shade700,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: incomeData.reduce((a, b) => a > b ? a : b) + 20000,
              // Dynamic background
              color: Colors.grey[300],
            ),
          ),
        ],
      );
    });
  }
}

// Months list for the X-axis
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
