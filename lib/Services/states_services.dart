import 'dart:convert';

import 'package:covid_tracker/Models/world_states_model.dart';
import 'package:covid_tracker/Utilities/app_urls.dart';
import 'package:http/http.dart' as http;

class StatesServices {
  
  Future<WorldStatesModel> fetchWorldStatesRecords() async {
    final response = await http.get(Uri.parse(AppUrl.worldStatesListApi));

    if (response.statusCode == 200) {
      var allData = jsonDecode(response.body.toString());

      return WorldStatesModel.fromJson(allData);
    } else {
      throw Exception('Error: failed to load states');
    }
  }

  Future<List<dynamic>> fetchCountriesRecords() async {
    final response = await http.get(Uri.parse(AppUrl.countriesListApi));

    if (response.statusCode == 200) {
      var allData = jsonDecode(response.body.toString());

      return allData;
    } else {
      throw Exception('Error: failed to load states');
    }
  }
}
