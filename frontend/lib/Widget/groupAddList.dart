import 'dart:math';

import 'package:flutter/material.dart';

class groupAddList extends StatefulWidget {
  final String username;
  final String category;
  final int friendId;
  final int currentId;
  final Set usersIds;
  final int index;

  const groupAddList({
    super.key,
    required this.username,
    required this.category,

    required this.friendId,
    required this.currentId,
    required this.usersIds,
    required this.index,
    //required this.onRemove,
  });

  @override
  State<groupAddList> createState() => _groupAddListState();
}

class _groupAddListState extends State<groupAddList> {
  bool checkboxValue = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));
    return Card(
      child: Container(
        width: screenWidth * 0.7,
        height: screenHeight * 0.09,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(theme.colorScheme.surfaceContainer.value),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                    child: Text(
                      widget.username,
                      style: TextStyle(fontSize: screenDiagonal * 0.017, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, left: 10.0),
                    child: Text(
                      widget.category,
                      style:  TextStyle(fontSize: screenDiagonal * 0.015, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 1.25,
              child: Checkbox(
                value: checkboxValue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (value) {
                setState(() {
                  checkboxValue = value ?? false;
                  if (checkboxValue) {
                    widget.usersIds.add(widget.friendId);
                  } else {
                    widget.usersIds.remove(widget.friendId);
                  }
                  print(widget.usersIds);
                });
              },
              ),
            )
          ],
        ),
      ),
    );
  }
}
