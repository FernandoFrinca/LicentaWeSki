import 'dart:math';

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
    final theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));

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
            color: Color(theme.colorScheme.surfaceContainer.value),
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
                  child: Icon(notification.iconData, size: cardHeight*0.55, color: Color(notification.iconColor | 0xFF000000),)
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: cardHeight * 0.06, left: cardHeight * 0.1),
                      child: Text(
                        notification.content,
                        style: TextStyle(fontSize: screenDiagonal * 0.016, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: cardHeight * 0.1),
                      child: Text(
                        "Send by: ${notification.senderName} ",
                        style: TextStyle(fontSize: screenDiagonal * 0.015, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: cardHeight * 0.1, left: cardHeight * 0.1),
                      child: Text(
                        "Group: ${notification.groupName} ",
                        style: TextStyle(fontSize: screenDiagonal * 0.015, color: Colors.grey),
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