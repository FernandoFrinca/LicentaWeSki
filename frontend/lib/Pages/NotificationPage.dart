import 'package:flutter/material.dart';
import 'package:weski/Widget/CustomSlider.dart';
import 'package:weski/Widget/friendCard.dart';
import '../Assets/Colors.dart';
import '../Assets/Theme.dart';
import '../ConcretObjects/User.dart';
import '../Widget/notificationCard.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int selectedIndex = 0;

  List<int> notifications = List.generate(10, (index) => index);
  List<int> requests = List.generate(10, (index) => index);

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
          onPressed: () => Navigator.pop(context, false),
        ),
        centerTitle: true,
        title: Text("Notifications", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
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
            SizedBox(height: 20),
            selectedIndex == 0
                ? Expanded(
              child: Container(
                width: screenWidth * 0.9,
                child: ScrollConfiguration(
                  behavior: ScrollBehavior().copyWith(overscroll: false),
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return notificationCard(
                        onDismiss: () {
                          setState(() {
                            notifications.removeAt(index);
                          });
                        }, cardHeight: cardHeight,
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
                  behavior: ScrollBehavior().copyWith(overscroll: false),
                  child: ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      return notificationCard(
                        onDismiss: () {
                          setState(() {
                            requests.removeAt(index);
                          });
                        }, cardHeight: cardHeight,
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.95,
              child: Divider(
                thickness: 2,
                color: Colors.black26,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0
              ),
              child: Container(
                width: screenWidth,
                height: 60,
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        notifications.clear();
                      });
                    },
                    icon: Icon(Icons.delete),
                    label: Text("Delete all notifications"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white
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
