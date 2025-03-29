import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class friendStatisticCard extends StatefulWidget {
  final String name;
  final String category;
  final String imagePath;
  final IconData firstIcon;
  final IconData secondIcon;
  final int fillColor;
  final double total_distance;
  final double max_speed;

  const friendStatisticCard({
    Key? key,
    required this.name,
    required this.category,
    required this.imagePath,
    this.firstIcon = Icons.speed,
    this.secondIcon = Icons.stacked_line_chart, required this.fillColor, required this.total_distance, required this.max_speed,
  }) : super(key: key);

  @override
  State<friendStatisticCard> createState() => _friendStatisticCardState();
}

class _friendStatisticCardState extends State<friendStatisticCard> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));

    return Padding(
      padding: EdgeInsets.all(screenDiagonal * 0.007),
      child: Container(
        //width: 170,
        decoration: BoxDecoration(
          color: Color(widget.fillColor),
          borderRadius: BorderRadius.circular(14),
        ),
        child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenDiagonal * 0.065,
                height: screenDiagonal * 0.065,
                margin: EdgeInsets.only(bottom: screenHeight * 0.008),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  image: widget.imagePath == "empty"
                      ? const DecorationImage(
                    image: AssetImage("assets/ski.jpeg"),
                    fit: BoxFit.cover,
                  )
                      : DecorationImage(
                    image: NetworkImage(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: screenDiagonal * 0.015,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.category,
                style: TextStyle(
                  fontSize: screenDiagonal * 0.013,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
             // const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Icon(widget.firstIcon, color: Colors.white),
                      AutoSizeText(
                        widget.max_speed == 0?"":
                        "${widget.max_speed} km/h",
                        style: TextStyle(color: Colors.white),
                        maxLines: 1,
                        minFontSize: 1,
                        maxFontSize: 13,
                      ),
                    ],
                  ),
                  SizedBox(width: screenWidth * 0.016),
                  Column(
                    children: [
                      Icon(widget.secondIcon, color: Colors.white),

                      AutoSizeText(
                        widget.total_distance == 0?"":
                        "${widget.total_distance} km",
                        style: TextStyle(color: Colors.white),
                        maxLines: 1,
                        minFontSize: 1,
                        maxFontSize: 13,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
    );
  }
}
