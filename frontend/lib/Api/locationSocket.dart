import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:weski/Api/userApi.dart';

import '../ConcretObjects/Friend.dart';
import 'consts.dart';

late List<Friend> friends;
final ValueNotifier<Map<int, Marker>> markersNotifier =
ValueNotifier<Map<int, Marker>>({});

final device = DeviceInfoPlugin();
StompClient? stompClient;

Future<String> getAddress() async {
  if (Platform.isAndroid) {
    final androidInfo = await device.androidInfo;
    if(androidInfo.isPhysicalDevice){
      return 'ws://${ipAddres}/weski';
    }else{
      return 'ws://10.0.2.2:8080/weski';
    }
  }else{
    final iosInfo = await device.iosInfo;
    if(iosInfo.isPhysicalDevice){
      return 'ws://${ipAddres}/weski';
    }else{
      return 'ws://10.0.2.2:8080/weski';
    }
  }
}

void initSocket(int UserId) async {
  friends = await userApi.fetchFriends(UserId);
  String url = await getAddress();
  stompClient = StompClient(
    config: StompConfig(
      url: url,
      onConnect: onConnect,
      onWebSocketError: (error) => print('WebSocket Error'),
      onStompError: (errorFrame) => print('STOMP Error'),
    ),
  );
  stompClient?.activate();
}


void onConnect(StompFrame frame) {
  stompClient?.subscribe(
    destination: '/location/updates',
    callback: (StompFrame frame) {
      if (frame.body != null) {
        final data = jsonDecode(frame.body!);
        final double lat = data['latitude'];
        final double lon = data['longitude'];
        final int userId = data['userId'];

        bool isFriend = friends.any((friend) => friend.id == userId);
        if(isFriend){
          final newMarker = Marker(
            markerId: MarkerId('user_$userId'),
            position: LatLng(lat, lon),
            infoWindow: InfoWindow(
              title: 'User $userId',
              snippet: 'location of friend',
            ),
          );

          final updatedMap = Map<int, Marker>.from(markersNotifier.value);
          updatedMap[userId] = newMarker;

          markersNotifier.value = updatedMap;
        }
      }
    },
  );
}

void sendLocation(double lat, double lon, int userId) {
  stompClient?.send(
    destination: '/app/newLocation',
    body: '{"latitude":$lat,"longitude":$lon,"userId":$userId}',
  );
}

void initWebSocket() {
  stompClient?.activate();
}

void closeSocket() {
  stompClient?.deactivate();
  stompClient = null;
}

