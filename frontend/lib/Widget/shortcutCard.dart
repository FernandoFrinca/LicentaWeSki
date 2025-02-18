import 'package:flutter/material.dart';
import 'package:weski/Api/notificationApi.dart';

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
              width: 170,
              height: 130,
              decoration: BoxDecoration(
                color: Color(widget.fillcolor),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.dataIcon, color: Colors.white, size: 56),
                  Text(
                    widget.text2,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.text1,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            Positioned(
              top: 45,
              right: widget.isleft ? -30 : 154,
              child: Container(
                width: 45,
                height: 40,
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
