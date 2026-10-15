import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountriesDetailScreen extends StatefulWidget {
  final String image, name;
  final int totalCases,
      totalDeaths,
      totalRecovered,
      active,
      critical,
      todayRecovered;
  const CountriesDetailScreen({
    super.key,
    required this.name,
    required this.image,
    required this.totalCases,
    required this.totalDeaths,
    required this.totalRecovered,
    required this.active,
    required this.critical,
    required this.todayRecovered,
  });

  @override
  State<CountriesDetailScreen> createState() => _CountriesDetailScreenState();
}

class _CountriesDetailScreenState extends State<CountriesDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 40, 43),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 35, 40, 43),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 48, 53, 56),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 94,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.flag_rounded,
                        color: Colors.white54,
                        size: 34,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'COVID-19 OVERVIEW',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.62),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Total Cases',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatNumber(widget.totalCases),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'CASE BREAKDOWN',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.62),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 48, 53, 56),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Column(
                children: [
                  _buildStatRow(
                    icon: Icons.coronavirus_rounded,
                    label: 'Active',
                    value: widget.active,
                    color: const Color(0xFF64B5F6),
                  ),
                  _buildStatRow(
                    icon: Icons.favorite_rounded,
                    label: 'Recovered',
                    value: widget.totalRecovered,
                    color: const Color(0xFF66BB6A),
                  ),
                  _buildStatRow(
                    icon: Icons.warning_rounded,
                    label: 'Critical',
                    value: widget.critical,
                    color: const Color(0xFFFFB74D),
                  ),
                  _buildStatRow(
                    icon: Icons.trending_up_rounded,
                    label: 'Deaths',
                    value: widget.totalDeaths,
                    color: const Color(0xFFEF5350),
                  ),
                  _buildStatRow(
                    icon: Icons.add_circle_rounded,
                    label: 'Recovered Today',
                    value: widget.todayRecovered,
                    color: const Color(0xFF80CBC4),
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                _formatNumber(value),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
      ],
    );
  }

  String _formatNumber(int value) {
    return NumberFormat('#,###').format(value);
  }
}
