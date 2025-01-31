import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpectedIncomeReport extends StatelessWidget {
  const ExpectedIncomeReport({super.key});

  @override
  Widget build(BuildContext context) {
    List<double> incomeData = [50000, 75000, 100000, 60000, 90000, 120000, 80000, 110000, 95000, 130000, 140000, 125000];
    double totalIncome = incomeData.reduce((a, b) => a + b); // Calculate total expected income

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expected Income Report',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Enable scrolling
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Expected Income per Month",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                height: MediaQuery.of(context).size.height * 0.55, // 70% screen height
                child: BarChart(
                  BarChartData(
                    barGroups: _generateBarGroups(incomeData),
                    minY: 30000, // Start y-axis at 30,000
                    maxY: 150000, // Set a reasonable max y-value
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            if (value < 30000) return const SizedBox(); // Hide values below 30,000
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
                          getTitlesWidget: (double value, TitleMeta meta) {
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
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), // Remove right numbers
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), // Remove top numbers
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: true, drawVerticalLine: false),
                  ),
                ),
              ),

              const SizedBox(height: 30), // Spacing before total income

              // Total Expected Income
              Text(
                "From the above chart, it is fair to conclude- \nTotal expected income this year: Ksh $totalIncome",
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
            width: 20, // Thicker bars
            color: Colors.greenAccent.shade700, // Change color to green
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 150000,
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
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
];
