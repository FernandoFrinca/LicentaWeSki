import 'dart:math';

import 'package:flutter/material.dart';


class sensorsCard extends StatelessWidget {
  final String title;
  final String secondText;
  final IconData iconData;
  final ValueNotifier<String>? valueNotifier;

  const sensorsCard({
    Key? key,
    required this.title,
    required this.iconData,
    this.secondText = "",
    required this.valueNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));

    return Container(
      decoration: BoxDecoration(
          color: Color(theme.colorScheme.primary.value),
          borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(

                  left: screenDiagonal * 0.0155,
                ),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.5)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenDiagonal * 0.0045),
                      child: Icon(iconData, size: screenDiagonal * 0.033, color: Colors.white,),
                    )
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(

                    left: screenDiagonal * 0.0055,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: screenDiagonal * 0.02,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      if (secondText.isNotEmpty)
                        Text(
                          secondText,
                          style: TextStyle(
                            fontSize: screenDiagonal * 0.015,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenDiagonal * 0.0055,
                    left: screenDiagonal * 0.0155,
                  ),
                  child:
                  ValueListenableBuilder(valueListenable: valueNotifier!, builder: (context,value,child){
                    return Text(
                      "$value",
                      style: TextStyle(
                        fontSize: screenDiagonal * 0.025,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
