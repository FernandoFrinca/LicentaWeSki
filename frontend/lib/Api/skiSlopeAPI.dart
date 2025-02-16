import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class skiSlopeApi {
  //static const String urlSlopesByResort = "http://192.168.0.193:8080/api/ski-resorts"; //camin
  static const String urlSlopesByResort = "http://192.168.0.105:8080/api/ski-resorts"; //acasa

  static Future<List?> fetchSlopesfromResort(int id) async {
    final endpointUrl = Uri.parse('$urlSlopesByResort/getByResort?resortId=$id');
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
        finalList.add(element['dificulty'] as String);
      }
    }
    return finalList;
  }

  static Future<Set<Polyline>> createPolyLines(int id) async{
    List<dynamic>? slopes = await fetchSlopesfromResort(id);
    Set<Polyline> listPolylines = {};

    print(slopes);

    if (slopes == null) {
      print("Slopes null ID: $id");
      return {};
    }

    for (int i = 0; i < slopes.length; i += 3) {
      String name = slopes[i];
      String difficulty  = slopes [i+2];
      int color = 0xFF0000FF;
      List<LatLng> coord = List<LatLng>.from(slopes[i + 1]);

      if(difficulty == "advanced"){
        color=0xFF000000;
      }

      listPolylines.add(
        Polyline(
          polylineId: PolylineId(name),
          points: coord,
          color: Color(color),
          width: 5,
        ),
      );
    }
    return listPolylines;
  }



}
