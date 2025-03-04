import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weski/Assets/LocationLogic.dart';


class customWheaterCard extends StatefulWidget {
  final int fillColor;
  final int textColor;
  final String conditie;
  final double temperature;

  const customWheaterCard({
    Key? key,
    required this.fillColor,
    required this.textColor,
    required this.conditie,
    required this.temperature,
  }) : super(key: key);

  @override
  customWheaterCardState createState() => customWheaterCardState();
}

class customWheaterCardState extends State<customWheaterCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenHeight, 2) + pow(screenWidth, 2));

    double iconSize = screenDiagonal * 0.025;
    double textSize = screenDiagonal * 0.018;

    IconData weatherIcon = Icons.wb_sunny;
    Color colorIconWeather = Color(0x00000000);

    if(widget.conditie.toLowerCase() == "clear"){
      weatherIcon = Icons.wb_sunny;
      colorIconWeather = Colors.amber;
    }
    else if(widget.conditie.toLowerCase() == "clouds"){
      weatherIcon = Icons.wb_cloudy;
      colorIconWeather = Colors.black26;
    }
    else if(widget.conditie.toLowerCase() == "rain"){
      weatherIcon = Icons.grain;
      colorIconWeather = Colors.lightBlue;
    }
    else if(widget.conditie.toLowerCase() == "snow"){
      weatherIcon = Icons.cloudy_snowing;
      colorIconWeather = Colors.lightBlue;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenDiagonal * 0.023,
        vertical: screenDiagonal * 0.015,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenDiagonal * 0.025),
        color: Color(widget.fillColor),
      ),
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${widget.temperature.toStringAsFixed(0)}°C',
            style: TextStyle(
              fontSize: textSize * 0.9,
              color: Color(widget.textColor),
            ),
          ),
          SizedBox(width: screenDiagonal * 0.005),
            Icon(
              weatherIcon,
              color: colorIconWeather,
              size: iconSize * 0.9,
            )
        ],
      ),
    );
  }
}
