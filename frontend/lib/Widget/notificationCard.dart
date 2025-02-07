import 'package:flutter/material.dart';

class notificationCard extends StatelessWidget {

  final double cardHeight;
  final VoidCallback onDismiss;

  const notificationCard({
    super.key,
    required this.cardHeight,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismiss(),
      background: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: screenWidth * 0.9,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ),
      ),
      child: Card(
        child: Container(
          width: screenWidth * 0.95,
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFF8F8F8),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 5.0,
                ),
                child: Container(
                  width: cardHeight * 0.8,
                  height: cardHeight * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      "assets/ski.jpeg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                      child: Text(
                        "Username",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                      child: Text(
                        "data",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}