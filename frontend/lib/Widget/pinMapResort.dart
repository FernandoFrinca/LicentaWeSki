import 'package:flutter/material.dart';

class pinMapResort extends StatelessWidget {
  final String avatarImage;
  final double size;
  final int color;
  final IconData icon;
  final int iconColor;

  const pinMapResort({
    super.key,
    required this.avatarImage,
    required this.color,
    required this.icon,
    required this.iconColor,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Color(color),
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0,3),
                spreadRadius: 4,
                blurRadius: 6
            )
          ]
      ),
      child: Icon(icon, color: Color(iconColor),),
    );
  }
}