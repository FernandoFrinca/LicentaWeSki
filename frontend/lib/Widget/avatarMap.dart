import 'package:flutter/material.dart';

class AvatarMap extends StatelessWidget {
  final String avatarImage;
  final double size;

  const AvatarMap({
    super.key,
    required this.avatarImage,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
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
      /*child:ClipOval(child:Image.asset(
        avatarImage,
      fit: BoxFit.fill,
    )),
*/
    );
  }
}