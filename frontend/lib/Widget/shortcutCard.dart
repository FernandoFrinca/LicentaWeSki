import 'package:flutter/material.dart';
import 'package:weski/Api/notificationApi.dart';
import 'dart:math';

class shortcutCard extends StatefulWidget {
  final String text1;
  final String text2;
  final IconData dataIcon;
  final int fillcolor;
  final bool isleft;
  final int chipcolor;
  final int notificationId;
  final int groupId;
  final int sederId;

  const shortcutCard({
    Key? key,
    required this.text1,
    required this.text2,
    required this.dataIcon,
    required this.fillcolor,
    this.isleft = true,
    required this.chipcolor,
    required this.notificationId,
    required this.groupId,
    required this.sederId,
  }) : super(key: key);

  @override
  State<shortcutCard> createState() => _shortcutCardState();
}

class _shortcutCardState extends State<shortcutCard> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          notificationApi.sendNotification(widget.notificationId, widget.groupId, widget.sederId);
        },
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: screenWidth * 0.38,
              height: screenHeight * 0.13,
              decoration: BoxDecoration(
                color: Color(widget.fillcolor),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.dataIcon, color: Colors.white, size: screenDiagonal * 0.052),
                  Text(
                    widget.text2,
                    style: TextStyle(
                      fontSize: screenDiagonal * 0.014,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenDiagonal * 0.004),
                  Text(
                    widget.text1,
                    style: TextStyle(
                      fontSize: screenDiagonal * 0.017,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenDiagonal * 0.004),
                ],
              ),
            ),
            Positioned(
              top: screenHeight * 0.045,
              right: widget.isleft ? -screenWidth * 0.067 : screenWidth * 0.345,
              child: Container(
                width: screenWidth * 0.103,
                height: screenHeight * 0.04,
                decoration: BoxDecoration(
                  color: Color(widget.chipcolor),
                  borderRadius: BorderRadius.circular(180),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
