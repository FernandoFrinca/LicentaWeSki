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
    print("imaginea in group: ");
    print("Profile pic for ${widget.name} = '${widget.imagePath}'");

    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: Color(widget.fillColor),
          borderRadius: BorderRadius.circular(14),
        ),
        child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  image: widget.imagePath == "empty"
                      ? DecorationImage(
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
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.category,
                style: const TextStyle(
                  fontSize: 14,
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
                        maxFontSize: 14,
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      Icon(widget.secondIcon, color: Colors.white),

                      AutoSizeText(
                        widget.total_distance == 0?"":
                        "${widget.total_distance} km",
                        style: TextStyle(color: Colors.white),
                        maxLines: 1,
                        minFontSize: 1,
                        maxFontSize: 14,
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
