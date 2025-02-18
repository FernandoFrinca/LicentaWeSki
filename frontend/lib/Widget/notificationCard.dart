import 'package:flutter/material.dart';
import 'package:weski/ConcretObjects/NotificationModel.dart';

class notificationCard extends StatelessWidget {

  final double cardHeight;
  final VoidCallback onDismiss;
  final NotificationModel notification;

  const notificationCard({
    super.key,
    required this.cardHeight,
    required this.onDismiss,
    required this.notification
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismiss(),
      background: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: screenWidth * 0.9,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ),
      ),
      child: Card(
        child: Container(
          width: screenWidth * 0.95,
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFF8F8F8),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 5.0,
                ),
                child: Container(
                  width: cardHeight * 0.8,
                  height: cardHeight * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(notification.backgroundColor),
                  ),
                  child: Icon(notification.iconData, size: 50, color: Color(notification.iconColor | 0xFF000000),)
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                      child: Text(
                        notification.content,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Send by: ${notification.senderName} ",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                      child: Text(
                        "Group: ${notification.groupName} ",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}