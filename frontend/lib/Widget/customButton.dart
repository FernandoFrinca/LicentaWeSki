import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class customButton extends StatelessWidget {
  final String data;
  final IconData icon;
  final int textColor;
  final double textSize;
  final int iconColor;
  final double screenWidth;
  final double screenHeight;
  final double paddingWidth;
  final double paddingHeight;
  final double paddingText;
  final double iconSize;
  final VoidCallback onTap;

  const customButton({
    super.key,
    required this.data,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.textSize,
    required this.screenWidth,
    required this.screenHeight,
    required this.paddingWidth,
    required this.paddingHeight,
    required this.onTap,
    required this.iconSize,
    required this.paddingText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenHeight * paddingHeight,
        left: screenWidth * paddingWidth,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              size: iconSize,
              color: Color(iconColor),
            ),
            Padding(
              padding: EdgeInsets.only(left: paddingText),
              child: AutoSizeText(
                data,
                style: TextStyle(
                  fontSize: textSize,
                  color: Color(textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
