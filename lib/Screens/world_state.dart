import 'package:covid_tracker/Models/world_states_model.dart';
import 'package:covid_tracker/Screens/countries_list.dart';
import 'package:covid_tracker/Services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:covid_tracker/Widgets/error_state.dart';

String _formatNumber(num? value) {
  return NumberFormat.compact().format(value ?? 0);
}

class WorldStatsScreen extends StatefulWidget {
  const WorldStatsScreen({super.key});

  @override
  State<WorldStatsScreen> createState() => _WorldStatsScreenState();
}

class _WorldStatsScreenState extends State<WorldStatsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Future<WorldStatesModel> _future;
  final StatesServices statesServices = StatesServices();

  @override
  void initState() {
    super.initState();
    _future = statesServices.fetchWorldStatesRecords();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Color> colorList = [
    Color(0xff4285F4),
    const Color.fromARGB(255, 206, 50, 3),
    Color(0xff1aa260),
    Color(0xffde5246),
  ];

  Future<void> _refresh() async {
    setState(() {
      _future = statesServices.fetchWorldStatesRecords();
    });
    try {
      await _future;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    // StatesServices statesServices = StatesServices();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 40, 43),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: FutureBuilder<WorldStatesModel>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitFadingCircle(
                          color: Colors.white,
                          controller: _controller,
                        ),
                        SizedBox(height: 4),
                        Text('Loading data...'),
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return ErrorState(error: snapshot.error, onRetry: _refresh);
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No data available'));
                } else {
                  final finalData = snapshot.data!;
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 4),
                          child: Text(
                            'Worldwide Statistics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Text(
                            'A summary of COVID-19 cases around the world',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.65),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Card(
                          color: const Color.fromARGB(255, 48, 53, 56),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Case distribution',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: PieChart(
                                    animationDuration: const Duration(
                                      seconds: 1,
                                    ),
                                    chartValuesOptions:
                                        const ChartValuesOptions(
                                          showChartValuesInPercentage: true,
                                        ),
                                    chartRadius:
                                        MediaQuery.of(context).size.width / 2.8,
                                    chartType: ChartType.ring,
                                    colorList: colorList,
                                    legendOptions: const LegendOptions(
                                      legendPosition: LegendPosition.left,
                                    ),
                                    dataMap: {
                                      'Total': finalData.cases!.toDouble(),
                                      'Active': finalData.active!.toDouble(),
                                      'Recovered': finalData.recovered!
                                          .toDouble(),
                                      'Deaths': finalData.deaths!.toDouble(),
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 22, bottom: 10),
                          child: Text(
                            'Worldwide case details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Card(
                          color: const Color.fromARGB(255, 48, 53, 56),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              ReusableRow(
                                title: 'Total Cases',
                                value: _formatNumber(finalData.cases),
                              ),
                              ReusableRow(
                                title: 'Deaths',
                                value: _formatNumber(finalData.deaths),
                              ),
                              ReusableRow(
                                title: 'Recovered',
                                value: _formatNumber(finalData.recovered),
                              ),
                              ReusableRow(
                                title: 'Active',
                                value: _formatNumber(finalData.active),
                              ),
                              ReusableRow(
                                title: 'Today Cases',
                                value: _formatNumber(finalData.todayCases),
                              ),
                              ReusableRow(
                                title: 'Today Deaths',
                                value: _formatNumber(finalData.todayDeaths),
                              ),
                              ReusableRow(
                                title: 'Today Recovered',
                                value: _formatNumber(finalData.todayRecovered),
                              ),
                              ReusableRow(
                                title: 'Critical',
                                value: _formatNumber(finalData.critical),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CountriesListScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.public_rounded),
                            label: const Text(
                              'Track Countries',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                24,
                                141,
                                84,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  const ReusableRow({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color.fromARGB(255, 74, 75, 75)),
        ],
      ),
    );
  }
}
