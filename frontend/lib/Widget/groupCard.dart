import 'dart:math';

import 'package:flutter/material.dart';

class groupCard extends StatelessWidget {
  final String groupName;
  final String groupPhoto;
  final VoidCallback onTap;

  const groupCard({
    Key? key,
    required this.groupName,
    required this.groupPhoto,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));
    double cardHeight = screenHeight * 0.21;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
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
                groupPhoto == "empty" ?
                  Image.asset(
                    "assets/ski.jpeg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ):
                  Image.network(groupPhoto,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                ),
                Container(
                  color: Colors.black.withOpacity(0.25),
                ),
                Positioned(
                  bottom: cardHeight * 0.1,
                  left: 10,
                  right: 10,
                  child: Text(
                    "Group $groupName",
                    style: TextStyle(
                      fontSize: screenDiagonal * 0.024,
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
      ),
    );
  }
}
