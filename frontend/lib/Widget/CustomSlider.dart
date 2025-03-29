
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final String text1;
  final String text2;
  final int sliderColor;
  final int selectedTextColor;
  final Function(int) onToggle;

  const CustomSlider({
    super.key,
    required this.text1,
    required this.text2,
    required this.sliderColor,
    required this.selectedTextColor,
    required this.onToggle,
  });

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));

    return Container(
      width: screenWidth * 0.45,
      height: screenHeight * 0.05,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment:
            selectedIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: screenWidth * 0.23,
              height: screenHeight * 0.05,
              decoration: BoxDecoration(
                color: Color(widget.sliderColor),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                    widget.onToggle(0);
                  },
                  child: Center(
                    child: Text(
                      widget.text1,
                      style: TextStyle(
                        fontSize: screenDiagonal * 0.013,
                        fontWeight: FontWeight.bold,
                        color: selectedIndex == 0 ? Color(widget.selectedTextColor) : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                    widget.onToggle(1);
                  },
                  child: Center(
                    child: Text(
                      widget.text2,
                      style: TextStyle(
                        fontSize: screenDiagonal * 0.013,
                        fontWeight: FontWeight.bold,
                        color: selectedIndex == 1 ? Color(widget.selectedTextColor) : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}