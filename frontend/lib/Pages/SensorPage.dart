import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../Widget/customTriangle.dart';
import '../Widget/sensorsCard.dart';
import '../Widget/statisticsCard.dart';


class SensorPage extends StatefulWidget {
  const SensorPage({super.key});

  @override
  SensorPageState createState() => SensorPageState();
}

class SensorPageState extends State<SensorPage> {
  late ValueNotifier<String> testNotifier = new ValueNotifier("testul");
  Color buttonColorLight = Colors.red;
  List<String> btOptions = [
    "Test1",
    "Test2",
    "Test3",
    "Test4",
    "Test5",
    "Test6",
    "Test7",
    "Test8",
    "Test9",
  ];


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(theme.colorScheme.primary.value,),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context, false),
        ),
        centerTitle: true,
        title: Text("Sensors", style: TextStyle(fontSize: screenDiagonal * 0.03, fontWeight: FontWeight.bold, color: Colors.white),),
      ),
      body:
      Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child:Container(
              width: screenWidth,
              height: screenHeight * 0.26,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                color: Colors.grey,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: screenHeight * 0.02
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color(theme.colorScheme.primary.value),
                  ),
                  width: screenWidth,
                  height: screenHeight * 0.24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //       top: screenHeight * 0.01,
                      //       left: screenWidth * 0.07,
                      //   ),
                      //   child: Text("Details:", style: TextStyle(fontSize: screenDiagonal * 0.028, fontWeight: FontWeight.bold, color: Colors.white),),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.015,
                          left: screenWidth * 0.07,
                          right: screenWidth * 0.07,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.07,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16.0,
                                  right: 8,
                                ),
                                child: Text(
                                  "Connected:",
                                  style: TextStyle(
                                    fontSize: screenDiagonal * 0.02,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding:  EdgeInsets.only(
                                        right:16.0
                                    ),
                                    child: Text(
                                      "numele dispozitivului conectatin acest moement:",
                                      style: TextStyle(
                                        fontSize: screenDiagonal * 0.02,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.07, top: screenHeight * 0.015, right: screenWidth * 0.07),
                        child: Row(
                          children: [
                            Expanded(
                              child: sensorsCard(
                                title: "Light",
                                secondText: "sensor",
                                iconData: Icons.lightbulb_outline_sharp,
                                valueNotifier: testNotifier,
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              child: RawMaterialButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (){
                                  setState(() {
                                    if(buttonColorLight == Colors.red){
                                      buttonColorLight = Colors.green;
                                    }else{
                                      buttonColorLight = Colors.red;
                                    }
                                  });
                                  print("Apasat Start/Stop");
                                },
                                child: CircleAvatar(
                                  radius: screenDiagonal * 0.04,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.power_settings_new_outlined, color: buttonColorLight, size: screenDiagonal * 0.035,),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ),
          ),
          Positioned(
              top: screenHeight * 0.28,
              left: screenWidth * 0.05,
              right: 0,
              child: Text("Avalible connections:", style: TextStyle(fontSize: screenDiagonal * 0.03, fontWeight: FontWeight.bold, color: Colors.black),)
          ),
          Positioned(
            top: screenHeight * 0.32,
            left: 0,
            right: 0,
            bottom: screenHeight * 0.06,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              itemCount: btOptions.length,
              separatorBuilder: (context, index) => Divider(height: 2, color: Colors.grey.shade300),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    print("Apasat pe: ${btOptions[index]}");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.020,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      btOptions[index],
                      style: TextStyle(
                        fontSize: screenDiagonal * 0.022,
                        fontWeight: FontWeight.w500,
                        color: Color(theme.colorScheme.primary.value),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: screenHeight * 0.78,
            left: screenWidth * 0.75,
            child: RawMaterialButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: (){
                print("Apasat Scan");
              },
              child: CircleAvatar(
                radius: screenDiagonal * 0.035,
                backgroundColor: Color(theme.colorScheme.primary.value),
                child: Icon(Icons.bluetooth_searching_outlined, color: Colors.white, size: screenDiagonal * 0.035,),
              ),
            ),
          )
        ],
      ),
    );
  }
}