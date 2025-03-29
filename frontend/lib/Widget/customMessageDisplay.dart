
import 'dart:math';

import 'package:flutter/material.dart';

import '../Assets/Theme.dart';
import '../ConcretObjects/SearchElement.dart';


class CustomMessageDisplay extends StatefulWidget {
  final int fillColor;
  final int textColor;
  final String textContent;
  final double screenHeight;
  final double screenWidth;
  final bool isFromUser;

  const CustomMessageDisplay({
    super.key,
    required this.fillColor,
    required this.textColor,
    required this.textContent,
    required this.screenWidth,
    required this.screenHeight,
    required this.isFromUser,
  });

  @override
  State<StatefulWidget> createState() => _CustomMessageDisplayState();
}

class _CustomMessageDisplayState extends State<CustomMessageDisplay> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double chatWidth = widget.screenWidth * 0.78;
    double chatHeight = widget.screenHeight * 0.1;
    double screenDiagonal = sqrt(pow(widget.screenWidth,2)+pow(widget.screenHeight,2));;
    double profileCircleSize  = screenDiagonal * 0.047;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if(!widget.isFromUser)
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              left: 10,
              right: 5,
            ),
            child:Container(
              width: profileCircleSize,
              height: profileCircleSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(180),
                child: Image.asset(
                  theme.brightness == lightTheme.brightness
                      ? "assets/goggles_lightmode.png"
                      : "assets/goggles_darkmode.png",
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),

        Padding(
          padding: const EdgeInsets.only(
              top: 8.0
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
                color: Color(widget.isFromUser ? widget.fillColor : theme.brightness == lightTheme.brightness? 0xFFC1E0EA : 0xFF47879C ),
            ),
            constraints: BoxConstraints(
              minHeight: profileCircleSize,
            ),
            width: chatWidth,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(widget.textContent),
            ),
          ),
        ),
        if(widget.isFromUser)
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              left: 10,
              right: 5,
            ),
            child:Container(
              width: profileCircleSize,
              height: profileCircleSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(180),
                child: Image.asset(
                  "assets/avatar.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
