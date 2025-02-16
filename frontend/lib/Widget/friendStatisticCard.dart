import 'package:flutter/material.dart';

class friendStatisticCard extends StatefulWidget {
  final String name;
  final String category;
  final String imagePath;
  final IconData firstIcon;
  final IconData secondIcon;
  final int fillColor;

  const friendStatisticCard({
    Key? key,
    required this.name,
    required this.category,
    required this.imagePath,
    this.firstIcon = Icons.speed,
    this.secondIcon = Icons.stacked_line_chart, required this.fillColor,
  }) : super(key: key);

  @override
  State<friendStatisticCard> createState() => _friendStatisticCardState();
}

class _friendStatisticCardState extends State<friendStatisticCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                  image: DecorationImage(
                    image: AssetImage(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                widget.category,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.firstIcon, color: Colors.white),

                  const SizedBox(width: 16),
                  Icon(widget.secondIcon, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
