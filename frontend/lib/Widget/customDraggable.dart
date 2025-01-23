import 'package:flutter/material.dart';
import 'package:weski/Widget/customWheaterTimerDisplay.dart';

class customDraggable extends StatefulWidget{
  final double screenHeight;
  final double screenWidth;

  const customDraggable({
    super.key,
    required this.screenWidth,
    required this.screenHeight
  });
  @override
  State<StatefulWidget> createState() => _customDraggable();
}

class _customDraggable extends State<customDraggable>{
  late String recordButtonText;
  late int recordButtonColor;
  late bool recordState;
  @override
  void initState() {
    recordButtonText = "Start";
    recordButtonColor = 0xFF3AFF6F;
    recordState = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double buttonsPaddingValue = widget.screenWidth * 0.04;
    double containersPaddingValue = widget.screenHeight * 0.02;
    double screenH = widget.screenHeight;
    double screenW = widget.screenWidth;
    double innerRadius = 35;
    double outterRadius = 30;
    return DraggableScrollableSheet(
      snap: true,
      snapAnimationDuration: const Duration(milliseconds: 500),
      initialChildSize: 0.15,
      minChildSize: 0.15,
      maxChildSize: 1,
      expand: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD3D3D3),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(outterRadius),
                topLeft: Radius.circular(outterRadius)
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: containersPaddingValue
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(innerRadius),
                  topLeft: Radius.circular(innerRadius)
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.only(top: containersPaddingValue),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: buttonsPaddingValue,
                            right: buttonsPaddingValue,
                        ),
                        child: Center(
                          child: customWheaterTimerDisplay(fillColor: 0xFFF0F0F0, textColor: 0XFF000000, screenWidth: screenW, screenHeight: screenH)
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: buttonsPaddingValue,
                          right: buttonsPaddingValue,
                        ),
                        child: Center(
                            child:ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if(!recordState){
                                    recordState = !recordState;
                                    recordButtonText = "Stop";
                                    recordButtonColor = 0xFFFF3A3A;
                                  }
                                  else{
                                    recordButtonText = "Start";
                                    recordButtonColor = 0xFF3AFF6F;
                                    recordState = false;
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Color(recordButtonColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                fixedSize: Size(screenW * 0.4, screenH * 0.0635),
                                //padding: EdgeInsets.symmetric(horizontal: screenW * 0.4;, vertical: screenH * 0.008),
                              ),
                              child:Text(
                                recordButtonText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}