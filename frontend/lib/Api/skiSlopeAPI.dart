import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'consts.dart';

class skiSlopeApi {
  static const String url = "$apiAddres/ski-resorts";
  static Future<List?> fetchSlopesfromResort(int id) async {
    final endpointUrl = Uri.parse('$url/getByResort/$id');
    try {
      final response = await http.get(endpointUrl);
      if (response.statusCode == 200) {
        print("intra 200");
        final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
        return processData(decodedBody['slopes'] as List<dynamic>);
      } else {
        print('Error');
        return null;
      }
    } catch (e) {
      print('Exception');
      return null;
    }
  }


  static List processData(List<dynamic> unprocessedData) {
    List<dynamic> finalList = [];

    for(var element in unprocessedData){
      if (element is Map<String, dynamic>) {
        finalList.add(element['name'] as String);
        List<dynamic> cooordonates = element['geom'] as List<dynamic>;
        List<LatLng> finalCoordonates = [];
        for(var cord in cooordonates){
          finalCoordonates.add(LatLng(cord[1], cord[0]));
        }
        finalList.add(finalCoordonates);
        finalList.add(element['difficulty'] as String);
      }
    }
    return finalList;
  }

  static Future<Set<Polyline>> createPolyLines(int id) async {
    List<dynamic>? slopes = await fetchSlopesfromResort(id);
    Set<Polyline> listPolylines = {};

    if (slopes == null) {
      print("Slopes null ID: $id");
      return {};
    }

    if (slopes.length % 3 != 0) {
      return {};
    }

    for (int i = 0; i < slopes.length; i += 3) {
      try {
        String name = slopes[i] as String;
        List<LatLng> coord = List<LatLng>.from(slopes[i + 1]);
        String difficulty = slopes[i + 2] as String;

        int color = 0xFF0000FF;
        if (difficulty.toLowerCase() == "advanced") {
          color = 0xFF000000;
        }

        listPolylines.add(
          Polyline(
            polylineId: PolylineId(name),
            points: coord,
            color: Color(color),
            width: 5,
          ),
        );
      } catch (e) {
        print("Eroare la procesarea elementelor pentru polilinie: $e");
      }
    }
    return listPolylines;
  }



}
