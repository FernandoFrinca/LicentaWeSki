import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:weski/Api/skiSlopeAPI.dart';
import 'package:weski/ConcretObjects/ChatObj.dart';

import 'consts.dart';

class skiResortApi {
  static const String url = "$apiAddres/ski-resorts";
  static Future<BitmapDescriptor> _loadCustomMarkerIcon() async {
    return await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(12, 12)),
      'assets/locationResort.png',
    );
  }

  static Future<Set<Marker>> createMarkers(
      List<dynamic> list,
      Completer<GoogleMapController> mapController,
      Function(Set<Polyline>) updatePolylines,
      ) async {
    Set<Marker> finalSet = {};
    BitmapDescriptor customMarkerIcon = await _loadCustomMarkerIcon();

    // print("\n\n\nid poliline intrare:");

    for (int i = 0; i < list.length; i += 4) {
      int id = list[i] as int;
      String name = list[i + 1] as String;
      double latitude = list[i + 2] as double;
      double longitude = list[i + 3] as double;

      finalSet.add(
        Marker(
          markerId: MarkerId(id.toString()),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: name),
          icon: customMarkerIcon,
          onTap: () async {
            // print("\n\n\nid poliline:");
            // print(id);
            Set<Polyline> listPolylines = await skiSlopeApi.createPolyLines(id) as Set<Polyline>;

            updatePolylines(listPolylines);

            final controller = await mapController.future;
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 15,
                ),
              ),
            );
          },
        ),
      );
    }

    return finalSet;
  }

  static Future<Set<Marker>> convertJson(
      List<dynamic> unconvertedList,
      Completer<GoogleMapController> mapController,
      Function(Set<Polyline>) updatePolylines
      ) async {
    List<dynamic> finalList = [];

    for (var element in unconvertedList) {
      if (element is Map<String, dynamic>) {
        finalList.add(element['id'] as int);
        finalList.add(element['name'] as String);
        finalList.add(element['latitude'] as double);
        finalList.add(element['longitude'] as double);
      }
    }
    return await createMarkers(finalList, mapController, updatePolylines);
  }

  static Future<Set<Marker>?> fetchResortsMarkers(
      Completer<GoogleMapController> mapController,
      Function(Set<Polyline>) updatePolylines
      ) async {
    final endpointUrl = Uri.parse('$url/getAll');
    try {
      final response = await http.get(endpointUrl);
      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body) as List<dynamic>;
        return await convertJson(decodedBody, mapController,updatePolylines);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  static Future<void> fetchResortsData() async {
    final endpointUrl = Uri.parse('$url/getAll');
    List<ResortBotData> finalList = [];
    try {
      final response = await http.get(endpointUrl);
      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body) as List<dynamic>;

        for (var element in decodedBody) {
          List<SlopeBotData> slopes = [];
          if (element['slopes'] != null) {
            for (var slopeElem in element['slopes']) {
              final rawGeom = slopeElem['geom'] as List<dynamic>;
              final geomData = rawGeom.map<List<double>>((coords) {
                final coordList = coords as List<dynamic>;
                return coordList.map<double>((val) => (val as num).toDouble()).toList();
              }).toList();

              SlopeBotData slope = SlopeBotData(
                name: slopeElem['name'] as String,
                difficulty: slopeElem['difficulty'] as String,
                geom: geomData,
              );

              slopes.add(slope);
            }

          }

          ResortBotData resort = new ResortBotData(
              latitude: element['latitude'] as double,
              longitude: element['longitude'] as double,
              name: element['name'] as String,
              slopes: slopes);

          finalList.add(resort);
        }

        //print(finalList);

      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
