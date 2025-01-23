
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';


class infoWidget extends StatefulWidget {
  final String selectedData;
  final IconData selectedI;
  final int selectediconColor;
  final int selectedtextColor;
  final double screenW;
  final double screenH;

  const infoWidget({
    super.key,
    required this.selectedData,
    required this.selectedI,
    required this.selectediconColor,
    required this.selectedtextColor,
    required this.screenW,
    required this.screenH,
  });

  @override
  State<StatefulWidget> createState() => _infoWidgetState();
}

class _infoWidgetState extends State<infoWidget> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = widget.screenW;
    double screenHeight = widget.screenW;
    String data = widget.selectedData;
    IconData selectedIcon = widget.selectedI;
    int iconColor = widget.selectediconColor;
    int textColor = widget.selectedtextColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:EdgeInsets.only(
            top: screenHeight * 0.02,
            left: screenWidth * 0.03,
          ),
          child: Icon(
            selectedIcon,
            size: screenWidth * 0.08,
            color: Color(iconColor),
          ),
        ),
        Padding(
          padding:EdgeInsets.only(
            top: screenHeight * 0.02,
            left: screenWidth * 0.01,
          ),
          child: AutoSizeText(
            data,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              color: Color(textColor),
            ),
          ),
        ),
      ],
    );
  }
}
