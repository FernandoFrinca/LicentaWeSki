import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weski/Assets/LocationLogic.dart';


class customWheaterTimerDisplay extends StatefulWidget {
  final int fillColor;
  final int textColor;
  final ValueNotifier<Duration> duration;

  const customWheaterTimerDisplay({
    Key? key,
    required this.fillColor,
    required this.textColor,
    required this.duration,
  }) : super(key: key);

  @override
  _customWheaterTimerDisplayState createState() => _customWheaterTimerDisplayState();
}

class _customWheaterTimerDisplayState extends State<customWheaterTimerDisplay> {
  @override
  void initState() {
    super.initState();
    getWeather();
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenHeight, 2) + pow(screenWidth, 2));

    double iconSize = screenDiagonal * 0.025;
    double textSize = screenDiagonal * 0.018;
    double dividerThickness = screenDiagonal * 0.0018;

    return ValueListenableBuilder<Duration>(
        valueListenable: widget.duration,
        builder: (context, durationValue, child) {
          return Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenDiagonal * 0.023,
            vertical: screenDiagonal * 0.015,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenDiagonal * 0.025),
            color: Color(widget.fillColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: weatherTempNotifier,
                    builder: (context, temperature, child) {
                      return Text(
                        '${temperature.toStringAsFixed(0)}°C',
                        style: TextStyle(
                          fontSize: textSize * 0.9,
                          color: Color(widget.textColor),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: screenDiagonal * 0.005),
                  ValueListenableBuilder<String>(
                    valueListenable: weatherCondNotifier,
                    builder: (context, conditie, child) {
                      IconData weatherIcon = Icons.wb_sunny;
                      Color colorIconWeather;
                      if(conditie.toLowerCase() == "clear"){
                        weatherIcon = Icons.wb_sunny;
                        colorIconWeather = Colors.amber;
                      }
                      else if(conditie.toLowerCase() == "clouds"){
                        weatherIcon = Icons.wb_cloudy;
                        colorIconWeather = Colors.white30;
                      }
                      else if(conditie.toLowerCase() == "rain"){
                        weatherIcon = Icons.grain;
                        colorIconWeather = Colors.lightBlue;
                      }
                      else if(conditie.toLowerCase() == "snow"){
                        weatherIcon = Icons.cloudy_snowing;
                        colorIconWeather = Colors.amber;
                      }
                      return Icon(
                        weatherIcon,
                        color: Colors.amber,
                        size: iconSize * 0.9,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: iconSize,
                child: VerticalDivider(
                  thickness: dividerThickness,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: screenDiagonal * 0.005),
                child: Text(
                  formatDuration(durationValue),
                  style: TextStyle(
                    fontSize: textSize,
                    color: Color(widget.textColor),
                  ),
                ),
              ),
            ],
          ),
          );
        },
    );
  }
}
