
import 'package:flutter/material.dart';


class customWheaterTimerDisplay extends StatefulWidget {
  final int fillColor;
  final int textColor;
  final double screenHeight;
  final double screenWidth;

  const customWheaterTimerDisplay({
    super.key,
    required this.fillColor,
    required this.textColor,
    required this.screenWidth,
    required this.screenHeight
  });

  @override
  State<StatefulWidget> createState() => _CustomWheaterTimerDisplayState();
}

class _CustomWheaterTimerDisplayState extends State<customWheaterTimerDisplay> {

  @override
  Widget build(BuildContext context) {

    double displayWidth = widget.screenWidth * 0.4;
    double displayHeight = widget.screenHeight * 0.0635;
    Stopwatch timer;

    return Container(
      width: displayWidth,
      height: displayHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Color(widget.fillColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           const Expanded(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   SizedBox(
                     width: 10,
                   ),
                   Text(
                    "-1*",
                    style: TextStyle(fontSize: 24),
                   ),
                   Icon(
                     Icons.sunny,
                     color: Colors.amber,
                     size: 30,
                   )
                 ],
               ),
           ),
          SizedBox(
            height: displayHeight * 0.6,
            child: const VerticalDivider(
              thickness: 2,
              color: Colors.black,
            ),
          ),
           const Expanded(
             child: Center(
               child: Text(
                "20 min",
                style: TextStyle(fontSize: 22),
                         ),
             ),
           ),
        ],
      ),
    );
  }
}
