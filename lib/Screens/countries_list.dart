import 'package:covid_tracker/Screens/countries_detail_screen.dart';
import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/Widgets/error_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

String _formatNumber(num? value) {
  return NumberFormat.compact().format(value ?? 0);
}

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({super.key});

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  late Future<List<dynamic>> _future;
  final StatesServices statesServices = StatesServices();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = statesServices.fetchCountriesRecords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = statesServices.fetchCountriesRecords();
    });
    try {
      await _future;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 40, 43),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 35, 40, 43),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Countries',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Explore COVID-19 statistics by country',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a country',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Colors.white70,
                      ),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 48, 53, 56),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.blueGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: FutureBuilder<List<dynamic>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _waitingState();
                    }
                    if (snapshot.hasError) {
                      return ErrorState(
                        error: snapshot.error,
                        onRetry: _refresh,
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text('No data available'));
                    } else {
                      final countries = snapshot.data!;
                      final filteredCountries = countries.where((country) {
                        final countryName = country['country'].toString();
                        return countryName.toLowerCase().contains(
                          _searchController.text.toLowerCase(),
                        );
                      }).toList();

                      if (filteredCountries.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: Colors.white.withValues(alpha: 0.55),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'No countries found',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                        itemCount: filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country = filteredCountries[index];
                          final countryName = country['country'].toString();
                          final flagUrl = country['countryInfo']['flag']
                              .toString();

                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            color: const Color.fromARGB(255, 48, 53, 56),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.06),
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: Image.network(
                                  flagUrl,
                                  width: 54,
                                  height: 42,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 54,
                                        height: 42,
                                        color: Colors.white10,
                                        child: const Icon(
                                          Icons.flag_rounded,
                                          color: Colors.white54,
                                        ),
                                      ),
                                ),
                              ),
                              title: Text(
                                countryName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  'Cases: ${_formatNumber(country['cases'])}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _formatNumber(country['deaths']),
                                    style: const TextStyle(
                                      color: Color(0xFFFF8A80),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    'Deaths',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CountriesDetailScreen(
                                      name: countryName,
                                      image: flagUrl,
                                      active: country['active'],
                                      critical: country['critical'],
                                      todayRecovered: country['todayRecovered'],
                                      totalCases: country['cases'],
                                      totalDeaths: country['deaths'],
                                      totalRecovered: country['recovered'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _waitingState() {
  return ListView.builder(
    itemCount: 4,
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade700,
        highlightColor: Colors.grey.shade500,
        child: Column(
          children: [
            ListTile(
              leading: Container(height: 55, width: 55, color: Colors.white),
              title: Container(height: 10, width: 80, color: Colors.white),
              subtitle: Container(height: 10, width: 80, color: Colors.white),
              trailing: Container(height: 10, width: 80, color: Colors.white),
            ),
          ],
        ),
      );
    },
  );
}