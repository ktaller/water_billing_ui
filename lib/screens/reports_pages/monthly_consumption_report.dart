import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyConsumptionReport extends StatelessWidget {
  const MonthlyConsumptionReport({super.key});

  @override
  Widget build(BuildContext context) {
    List<double> consumptionData = [115, 75, 100, 60, 90, 120, 80, 110, 95, 130, 140, 125];
    double totalConsumption = consumptionData.reduce((a, b) => a + b); // Calculate total consumption

    return Scaffold(
      appBar: AppBar(
        title: const Text(style: TextStyle(color: Colors.white ), 'Monthly Consumption Report'),
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Make the page scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Consumption per Month",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                height: MediaQuery.of(context).size.height * 0.55, // Chart takes 70% of screen height
                child: BarChart(
                  BarChartData(
                    barGroups: _generateBarGroups(consumptionData),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true, reservedSize: 40,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Text('${value.toInt()}');
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
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
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),  // Removes numbers on the right
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),    // Removes numbers on top
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),

              const SizedBox(height: 30), // Space before total consumption statement

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
            width: 20, // Thicker bars
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
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
];
