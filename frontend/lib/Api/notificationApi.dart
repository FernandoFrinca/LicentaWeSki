import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weski/ConcretObjects/NotificationModel.dart';
import 'consts.dart';

class notificationApi {
  static const String url = "$ipAddres/notifications";
  static Future<void> sendNotification(int notifId, int groupId, int currentUserId)async {
    final endpointUrl = Uri.parse('$url/sentNotification/group');
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
      };
      print("\n");
      print(notifId);
      print(groupId);
      print(currentUserId);
      print("\n");
      final encodedBody = {
        "groupId": groupId,
        "senderId": currentUserId,
        "notificationId": notifId
      };
      final response = await http.post(
        endpointUrl,
        headers: headers,
        body: jsonEncode(encodedBody),
      );
      if(response.statusCode == 200){
        print("trimis cu succes");
      }else{
        print("eroare la trimitere");
      }
    }catch(e){
      print("catch eroare la trimitere");
    }
  }

  static Future<List<NotificationModel>> fetchAvalibleNotifications () async{
    final endpointUrl = Uri.parse('$url/getAll');
    final response = await http.get(endpointUrl);

    List<dynamic> notifications = jsonDecode(response.body);
    List<NotificationModel > resultList = [];

    for(var notif in notifications){
      NotificationModel  auxNotif = NotificationModel (
          notif['id'],
          notif['content'],
          notif['senderName'] == null ? "sender" : notif['senderName'],
          notif['groupName'] == null ? "groupName" : notif['groupName'],
          notif['sentNotificationId'] == null ? 0 : notif['sentNotificationId']
      );
      resultList.add(auxNotif);
    }
    return resultList;
  }

  static Future<List<NotificationModel >> fetchUserNotifications (int currentUserId) async{
    final endpointUrl = Uri.parse('$url/user/$currentUserId');
    final response = await http.get(endpointUrl);


    List<NotificationModel> availibleNotification = await fetchAvalibleNotifications();
    List<dynamic> notifications = jsonDecode(response.body);
    List<NotificationModel > resultList = [];

    final availableId = <int>{};
    for (var availableNotif in availibleNotification) {
      availableId.add(availableNotif.id);
    }

    for(var notif in notifications){
      NotificationModel  auxNotif = NotificationModel (
          notif['id'],
          notif['content'],
          notif['senderName'],
          notif['groupName'],
          notif['sentNotificationId']
       );
      if (availableId.contains(auxNotif.id)) {
          if(auxNotif.id == 1){
            auxNotif.setBackgroundColor(0xFF824E41);
            auxNotif.setIconColor(0xFFB4948D);
            auxNotif.setIconData(Icons.free_breakfast);
          }else if(auxNotif.id == 2){
            auxNotif.setBackgroundColor(0xFF2FDF7B);
            auxNotif.setIconColor(0xFF97EFBD);
            auxNotif.setIconData(Icons.downhill_skiing);
          }else if(auxNotif.id == 3){
            auxNotif.setBackgroundColor(0xFFEB5B2E);
            auxNotif.setIconColor(0xFFF5AD96);
            auxNotif.setIconData(Icons.settings);
          }
          else if(auxNotif.id == 4){
            auxNotif.setBackgroundColor(0xFF007EA7);
            auxNotif.setIconColor(0xFF7FBED3);
            auxNotif.setIconData(Icons.groups);
          }
          else if(auxNotif.id == 5){
            auxNotif.setBackgroundColor(0xFFCF0C18);
            auxNotif.setIconColor(0xFFE7858B);
            auxNotif.setIconData(Icons.warning);
          }
          else if(auxNotif.id == 6){
            auxNotif.setBackgroundColor(0xFFFFD800);
            auxNotif.setIconColor(0xFFFFEB7F);
            auxNotif.setIconData(Icons.home);
          }else{
            auxNotif.setBackgroundColor(0xFFFFFFFF);
            auxNotif.setIconColor(0xFFFFFFFF);
            auxNotif.setIconData(Icons.miscellaneous_services_sharp);
          }
      }
      resultList.add(auxNotif);
    }
    return resultList;
  }

  static Future<void> deleteNotifications(List<int> notificationsIds) async{
    final endpointUrl = Uri.parse('$url/deleteNotifications');

    final response = await http.delete(
      endpointUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(notificationsIds),
    );
    print(response.statusCode);
  }



}
