import 'dart:convert';

import 'package:earthquake/models/earthquake_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EarthquakeProvider extends ChangeNotifier {
  EarthquakeModel? earthquakeModel;

  String? startDate;
  String? endDate;
  num magnitude = 3;

  bool get hasDataLoaded => earthquakeModel != null;

  getEarthquakeReport() async {
    final uri = Uri.parse(
        'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=$startDate&endtime=$endDate&minmagnitude=$magnitude&orderby=time&orderby=magnitude');

    try {
      final response = await get(uri);
      final map = jsonDecode(response.body);

      if (response.statusCode == 200) {
        earthquakeModel = EarthquakeModel.fromJson(map);
        print(earthquakeModel!.features!.length);
        notifyListeners();
      } else {
        print('something went wrong');
      }
    } catch (e) {
      rethrow;
    }
  }
}
