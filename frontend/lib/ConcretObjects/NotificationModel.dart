import 'package:flutter/cupertino.dart';

class NotificationModel  {
  late int id;
  late int sentNotificationId;
  late String content;
  late String senderName;
  late String groupName;
  late int backgroundColor;
  late int iconColor;
  late IconData iconData;

  NotificationModel  (int id, String content, String senderName, String groupName, int sentNotificationId){
    this.id = id;
    this.content = content;
    this.senderName = senderName;
    this.groupName = groupName;
    this.sentNotificationId = sentNotificationId;
  }

  int getId(){
    return id;
  }

  int getSentNotificationId(){
    return sentNotificationId;
  }

  String getContent(){
    return content;
  }

  String getSenderName(){
    return senderName;
  }

  String getGroupName(){
    return groupName;
  }

  void setIconData(IconData iconData){
    this.iconData = iconData;
  }

  void setBackgroundColor(int backgroundColor){
    this.backgroundColor = backgroundColor;
  }

  void setIconColor(int iconColor){
    this.iconColor = iconColor;
  }
  @override
  String toString() {
    return 'id: $id, content: $content, content: $senderName, groupName: $groupName';
  }
}
