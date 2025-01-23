import 'package:flutter/material.dart';
import 'package:weski/Widget/customWheaterTimerDisplay.dart';

class customProfileAvatar extends StatefulWidget{
  final double screenHeight;
  final double screenWidth;

  const customProfileAvatar({
    super.key,
    required this.screenWidth,
    required this.screenHeight
  });
  @override
  State<StatefulWidget> createState() => _customProfileAvatar();
}

class _customProfileAvatar extends State<customProfileAvatar>{
  @override
  Widget build(BuildContext context) {
    double screenH = widget.screenHeight;
    double screenW = widget.screenWidth;
    return Padding(
      padding:EdgeInsets.only(
          top: 10.0,
          left: 18
      ),
      child: Container(
        width: screenW * 0.46,
        height: screenW * 0.46,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFF007EA7),
              ],
              stops: [0.5, 0.5],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(180),
            child: Image.asset(
              "assets/avatar.jpeg",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

}