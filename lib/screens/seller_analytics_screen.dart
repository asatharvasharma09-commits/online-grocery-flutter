import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SellerAnalyticsScreen extends StatelessWidget {
  const SellerAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF3D8BF2);

    final List<FlSpot> salesData = const [
      FlSpot(0, 2.3),
      FlSpot(1, 3.5),
      FlSpot(2, 1.9),
      FlSpot(3, 4.2),
      FlSpot(4, 3.6),
      FlSpot(5, 5.0),
      FlSpot(6, 4.1),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Full Analytics"),
        centerTitle: true,
        backgroundColor: primaryBlue,
      ),
      backgroundColor: const Color(0xFFF6F7FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 🔹 Sales Chart
            Container(
              height: 220,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 4))
                ],
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          if (value >= 0 && value < days.length) {
                            return Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: primaryBlue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: primaryBlue.withOpacity(0.15),
                      ),
                      spots: salesData,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 KPI Summary
            const Text(
              "Key Insights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _analyticsTile("Total Sales", "₹42,000", Icons.trending_up),
            _analyticsTile("Orders Completed", "198", Icons.shopping_bag_outlined),
            _analyticsTile("New Customers", "26", Icons.people_alt_outlined),
            _analyticsTile("Average Order Value", "₹212", Icons.attach_money_rounded),
            _analyticsTile("Customer Rating", "4.7 ★", Icons.star_rate_rounded),
          ],
        ),
      ),
    );
  }

  Widget _analyticsTile(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF3D8BF2)),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 15, color: Colors.black87))),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}