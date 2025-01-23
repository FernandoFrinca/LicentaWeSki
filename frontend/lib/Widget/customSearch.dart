
import 'package:flutter/material.dart';


class CustomSearchBar extends StatefulWidget {
  final int fillColor;
  final int textColor;
  final double screenHeight;
  final double screenWidth;

  const CustomSearchBar({
    super.key,
    required this.fillColor,
    required this.textColor,
    required this.screenWidth,
    required this.screenHeight
  });

  @override
  State<StatefulWidget> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {

  @override
  Widget build(BuildContext context) {

    double barWidth = widget.screenWidth * 0.45;
    double barHeight = widget.screenHeight * 0.06;

    return SizedBox(
      width: barWidth,
      height: barHeight,
      child:
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
              hintText: "Search",
              hintStyle: TextStyle(
                color: Colors.grey.shade600,
              ),
              filled: true,
              fillColor: Color( widget.fillColor),
              contentPadding: EdgeInsets.only(
                top: barHeight * 0.03,
                bottom: barHeight * 0.03,
                left: barWidth * 0.03,
                right: barWidth * 0.3,
              ),
              suffixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade600,
              ),
            ),
          ),
    );
  }
}
