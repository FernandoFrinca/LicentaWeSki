import 'package:flutter/material.dart';

class groupCard extends StatelessWidget {

  final double cardHeight;
  final String groupName;

  const groupCard({
    super.key,
    required this.cardHeight,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Card(
      child: Container(
        width: screenWidth * 0.3,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Stack(
                children: [
                  Image.asset(
                    "assets/ski.jpeg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.25),
                  ),
                ],
              ),
              Positioned(
                bottom: cardHeight * 0.1,
                left: 10,
                right: 10,
                child: Text(
                  "Group $groupName ",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
