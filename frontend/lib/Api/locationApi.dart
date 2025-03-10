import 'dart:convert';
import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'consts.dart';

class locationApi {
  static const String url = "$apiAddres/locations";

  static Future<void> saveUserData(int user_id, double lat, double lng)async {
    final endpointUrl = Uri.parse('$url/post');
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    final encodedBody = {
      "user_id": user_id,
      "latitude": lat,
      "longitude": lng
    };
    final response = await http.post(
      endpointUrl,
      headers: headers,
      body: jsonEncode(encodedBody),
    );
    if(response.statusCode == 200){
      print("Merge");
    }else{
      print("eroare la adaugare");
    }
  }

  static Future<Polyline> createUserPolylineTrack(int user_id)async {
    final endpointUrl = Uri.parse('$url/get/$user_id');
    final response = await http.get(endpointUrl);
    if(response.statusCode == 200){
      List<dynamic> decodedBody = jsonDecode(response.body);
      List<LatLng> points = [];
      for(var elem in decodedBody){
        double lat = elem['latitude'];
        double lng = elem['longitude'];
        LatLng point = LatLng(lat, lng);
        points.add(point);
      }
      return Polyline(
        polylineId: PolylineId("User_Track"),
        points: points,
        color: Color(0xFFFA6D0F),
        width: 5,
      );

    }else{
      print("eroare la creare traseu");
      return Polyline(polylineId: PolylineId("empty"));
    }
  }

  static Future<void> celarTrackData(int user_id)async{
    final endpointUrl = Uri.parse('$url/clearData/$user_id');
    final response = await http.delete(endpointUrl);
    if(response.statusCode == 200){
      print("Track sters");
    }else{
      print("eroare la stergere");
    }
  }


}