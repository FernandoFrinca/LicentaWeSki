import 'package:flutter/material.dart';
import 'package:weski/Api/notificationApi.dart';
import 'package:weski/ConcretObjects/NotificationModel.dart';
import 'package:weski/Widget/CustomSlider.dart';
import 'package:weski/Widget/friendCard.dart';
import '../Api/userApi.dart';
import '../ConcretObjects/Friend.dart';
import '../ConcretObjects/User.dart';
import '../Widget/notificationCard.dart';

class NotificationPage extends StatefulWidget {
  final int curentUserId;
  const NotificationPage({Key? key, required this.curentUserId}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int selectedIndex = 0;
  List<NotificationModel> notifications = [];
  List<int> deletedNotifications = [];
  List<Friend> _requests = [];

  @override
  void initState() {
    super.initState();

    userApi.fetchFriendRequests(widget.curentUserId).then((fetchedRequests) {
      setState(() {
        _requests = fetchedRequests;
      });
    });

    notificationApi.fetchUserNotifications(widget.curentUserId).then((fetchedNotifications) {
      setState(() {
        notifications = fetchedNotifications;
      });
    });
  }

  void removeFriendFromList(int index) {
    setState(() {
      _requests.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double cardHeight = screenHeight * 0.1;
    User? currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () async => {
            await notificationApi.deleteNotifications(deletedNotifications),
            Navigator.pop(context, false)
          },
        ),
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            CustomSlider(
              text1: "Notif",
              text2: "Requests",
              sliderColor: theme.colorScheme.primary.value,
              selectedTextColor: theme.colorScheme.onPrimary.value,
              onToggle: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            const SizedBox(height: 20),
            selectedIndex == 0
                ? Expanded(
              child: Container(
                width: screenWidth * 0.9,
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return notificationCard(
                        onDismiss: () {
                          setState(() {
                            deletedNotifications.add(notifications[index].sentNotificationId);
                            notifications.removeAt(index);
                          });
                        },
                        cardHeight: cardHeight,
                        notification: notifications[index]
                      );
                    },
                  ),
                ),
              ),
            )
                : Expanded(
              child: Container(
                width: screenWidth * 0.9,
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView.builder(
                    itemCount: _requests.length,
                    itemBuilder: (context, index) {
                      return friendCard(
                        cardHeight: cardHeight,
                        category: _requests[index].category,
                        username: _requests[index].username,
                        currentId: widget.curentUserId,
                        friendId: _requests[index].id,
                        requests: _requests,
                        index: index,
                        isItRequest: true,
                        onRemove: () => removeFriendFromList(index),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.95,
              child: const Divider(
                thickness: 2,
                color: Colors.black26,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                width: screenWidth,
                height: 60,
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      for(var notif in notifications){
                        deletedNotifications.add(notif.sentNotificationId);
                      }
                      setState(() {
                        notifications.clear();
                      });
                      await notificationApi.deleteNotifications(deletedNotifications);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete all notifications"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
