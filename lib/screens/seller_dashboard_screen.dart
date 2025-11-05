import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'seller_profile_page.dart';
import 'seller_main_tabs.dart'; // ✅ make sure this import exists
import 'seller_analytics_screen.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  String _selectedRange = '7 Days';

  // ✅ KPI Data
  final List<Map<String, String?>> _kpis = [
    {'label': 'Revenue', 'value': '₹12,400', 'delta': '+12%'},
    {'label': 'Avg. Order Value', 'value': '₹250', 'delta': '+3%'},
    {'label': 'Pending Orders', 'value': '8', 'delta': '-2%'},
    {'label': 'Products', 'value': '28', 'delta': null},
    {'label': 'Low Stock', 'value': '3', 'delta': '-8%'},
    {'label': 'Conversion', 'value': '3.5%', 'delta': '+0.3%'},
  ];

  // 📊 Sales Trend Data
  final List<FlSpot> _salesSpots = const [
    FlSpot(0, 2),
    FlSpot(1, 2.8),
    FlSpot(2, 1.5),
    FlSpot(3, 3.2),
    FlSpot(4, 2.8),
    FlSpot(5, 4.5),
    FlSpot(6, 3.9),
  ];

  // ⚠️ Alerts
  final List<String> _alerts = [
    '3 products are low on stock',
    'Order #1002 payment failed',
    'New review needs a reply',
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF3D8BF2);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text('Seller Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SellerProfilePage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👋 Greeting + timeframe picker
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Welcome back, Seller 👋",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedRange,
                        items: const [
                          DropdownMenuItem(
                              value: 'Today', child: Text('Today')),
                          DropdownMenuItem(
                              value: '7 Days', child: Text('7 Days')),
                          DropdownMenuItem(
                              value: '30 Days', child: Text('30 Days')),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => _selectedRange = v);
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 📊 Today summary bar
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _performanceMetric("Today’s Orders", "12"),
                    _performanceMetric("New Customers", "5"),
                    _performanceMetric("Sales", "₹1,540"),
                  ],
                ),
              ),

              // 🧾 KPI Cards — horizontal scroll
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _kpis.length,
                  itemBuilder: (context, index) {
                    final k = _kpis[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 12,
                        right: index == _kpis.length - 1 ? 8 : 0,
                      ),
                      child: _kpiCard(
                        k['label']!,
                        k['value']!,
                        k['delta'],
                        primaryBlue,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 📈 Sales Trend Chart
              const Text(
                'Sales Trend',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Container(
                height: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
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
                            const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                            if (value >= 0 && value < days.length) {
                              return Text(
                                days[value.toInt()],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
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
                          color: primaryBlue.withOpacity(0.12),
                        ),
                        spots: _salesSpots,
                      ),
                    ],
                  ),
                ),
              ),

              // 🔍 View Analytics Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SellerAnalyticsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.analytics_outlined,
                      color: Color(0xFF3D8BF2)),
                  label: const Text(
                    "View Full Analytics",
                    style: TextStyle(
                      color: Color(0xFF3D8BF2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ⚠️ Alerts & To-Dos
              const Text(
                'Alerts & To-Dos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Column(
                children: _alerts.map((a) => _alertTile(a)).toList(),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 📊 KPI Card Widget
  Widget _kpiCard(String label, String value, String? delta, Color color) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 13, color: Colors.black54)),
              const Spacer(),
              if (delta != null)
                Text(
                  delta,
                  style: TextStyle(
                    fontSize: 12,
                    color: delta.startsWith('-') ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ⚠️ Alert Tile Widget
  Widget _alertTile(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Action taken for: $text"),
                  backgroundColor: const Color(0xFF3D8BF2),
                ),
              );
            },
            child: const Text('Resolve',
                style: TextStyle(color: Color(0xFF3D8BF2))),
          ),
        ],
      ),
    );
  }
}

// 📈 Performance Metric Widget
class _performanceMetric extends StatelessWidget {
  final String label;
  final String value;
  const _performanceMetric(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
      ],
    );
  }
}