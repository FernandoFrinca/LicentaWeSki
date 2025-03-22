import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';
import 'package:weski/Api/consts.dart';
import 'package:weski/ConcretObjects/DistanceData.dart';
import 'package:weski/Widget/customWeather.dart';
import 'package:weski/Widget/customWheaterTimerDisplay.dart';
import 'package:weski/Widget/statisticsCard.dart';


import '../Api/locationApi.dart';
import '../Assets/LocationLogic.dart';
import '../ConcretObjects/User.dart';
import 'chartWidget.dart';

class customDraggable extends StatefulWidget{
  final double screenHeight;
  final double screenWidth;
  final User currentUser;
  final ValueNotifier<double> speedNotifier;
  final ValueNotifier<double> totalDistanceNotifier;
  final ValueNotifier<double> averageSpeedNotifier;
  final ValueNotifier<double> maxAltitudeNotifier;
  final ValueNotifier<Polyline> userTrackPolylineNotifier;

  const customDraggable({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.speedNotifier,
    required this.currentUser,
    required this.totalDistanceNotifier,
    required this.averageSpeedNotifier,
    required this.maxAltitudeNotifier,
    required this.userTrackPolylineNotifier,
  });
  @override
  State<StatefulWidget> createState() => _customDraggable();
}

class _customDraggable extends State<customDraggable>{
  late String recordButtonText;
  late int recordButtonColor;
  late int recordState = 0;
  ValueNotifier<Polyline> userTrack = ValueNotifier(Polyline(polylineId: PolylineId("Empty")));
  ValueNotifier<Duration> stopwatch = ValueNotifier(Duration.zero);
  ValueNotifier<List<DistanceData>> distancePerHour = ValueNotifier([]);

  Timer? timer;
  Timer? timerHour;
  DateTime? startTime;
  double currentDistance = 0.0;
  double lastDistance = 0.0;

  void startStopwatch() {

    startTime = DateTime.now();
    lastDistance = widget.totalDistanceNotifier.value;

    if (timer != null && timer!.isActive) return;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      stopwatch.value += const Duration(seconds: 1);
    });

    timerHour = Timer.periodic(const Duration(minutes: 1), (timer) {
      DateTime currentTime = startTime!.add(stopwatch.value);
      double updatedTotalDistance = widget.totalDistanceNotifier.value;
      currentDistance = updatedTotalDistance - lastDistance;
      lastDistance = updatedTotalDistance;

      DistanceData distanceHour = DistanceData(
          "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}",
          (currentDistance * 3.6)
      );

      distancePerHour.value.add(distanceHour);
      distancePerHour.notifyListeners();
    });
  }


  Future<void> stopStopwatch() async {
    widget.userTrackPolylineNotifier.value = await locationApi.createUserPolylineTrack(widget.currentUser.id);
    widget.userTrackPolylineNotifier.notifyListeners();
    print("Polyline track Points: ${widget.userTrackPolylineNotifier.value.points}");
    stopLocationSaving();
    timer?.cancel();
    timerHour?.cancel();
    resetData();
  }

  void resetStopwatch() async{
    await locationApi.celarTrackData(widget.currentUser.id);
    widget.userTrackPolylineNotifier.value = Polyline(polylineId: PolylineId("Empty"), points: [],);
    widget.userTrackPolylineNotifier.notifyListeners();
    stopwatch.value = Duration.zero;
  }

  void clearDataChart(){
    distancePerHour.value.clear();
    distancePerHour.notifyListeners();
  }


  @override
  void initState() {
    recordButtonText = "Start";
    recordButtonColor = 0xFF3AFF6F;
    recordState = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double paddingButton = widget.screenWidth * 0.03;
    double paddingCont = widget.screenHeight * 0.02;
    double screenH = widget.screenHeight;
    double screenW = widget.screenWidth;
    double screenD = sqrt(pow(screenW, 2) + pow(screenH, 2));

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
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30)
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: paddingCont
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color(theme.colorScheme.surface.value),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(35),
                  topLeft: Radius.circular(35)
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.only(top: paddingCont),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: paddingButton,
                            right: paddingButton,
                        ),
                        child: Center(
                          child: customWheaterTimerDisplay(fillColor: 0xFFF0F0F0, textColor: 0XFF000000, duration:stopwatch)
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: paddingButton,
                          right: paddingButton,
                        ),
                        child: Center(
                            child:ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if(recordState == 0){
                                    startStopwatch();
                                    recordState = 1;
                                    recordButtonText = "Stop";
                                    recordButtonColor = 0xFFFF3A3A;
                                    isRecordingNotifier.value = true;
                                  }
                                  else if(recordState == 1){
                                    stopStopwatch();
                                    recordButtonText = "Exit";
                                    recordButtonColor = 0xFFFF3A3A;
                                    recordState = 2;
                                    isRecordingNotifier.value = false;
                                  }else{
                                    resetStopwatch();
                                    clearDataChart();
                                    recordState = 0;
                                    recordButtonText = "Start";
                                    recordButtonColor = 0xFF3AFF6F;
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Color(recordButtonColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                fixedSize: Size(screenD * 0.15, screenD * 0.055),
                              ),
                              child:Text(
                                recordButtonText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenD * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical:20,
                      horizontal:16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Next 5 days",
                          style: TextStyle(
                            fontSize: screenD * 0.025,
                            fontWeight: FontWeight.w500,
                            color: Color(theme.colorScheme.onSurface.value).withOpacity(0.4),
                            height: 0.8,
                          ),
                        ),
                        Text(
                          "Weather:",
                          style: TextStyle(
                            fontSize: screenD * 0.03,
                            fontWeight: FontWeight.w500,
                            color: Color(theme.colorScheme.onTertiary.value),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
              ValueListenableBuilder<List<List<dynamic>>>(
                valueListenable: weatherFiveDaysNotifier,
                builder: (context, weatherData, child) {
                  return SizedBox(
                    height: screenD * 0.05,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weatherData.length,
                      itemBuilder: (context, index) {
                        String cond= weatherData[index][0];
                        double? temp = weatherData[index][1];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: customWheaterCard(
                            fillColor: 0xFFF0F0F0,
                            textColor: 0XFF000000,
                            conditie: cond,
                            temperature: temp ?? 0.0,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical:20,
                      horizontal:16,
                    ),
                    child:
                    ValueListenableBuilder<List<DistanceData>>(
                      valueListenable: distancePerHour,
                      builder: (context, distanceList, _) {
                        return  chartWidget(initialTime: startTime, realDistanceData: distancePerHour);
                      },
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical:20,
                      horizontal:16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.currentUser.username}'s",
                          style: TextStyle(
                            fontSize: screenD * 0.025,
                            fontWeight: FontWeight.w500,
                            color: Color(theme.colorScheme.onSurface.value).withOpacity(0.4),
                            height: 0.8,
                          ),
                        ),
                        Text(
                          "Statistics:",
                          style: TextStyle(
                            fontSize: screenD * 0.03,
                            fontWeight: FontWeight.w500,
                            color: Color(theme.colorScheme.onTertiary.value),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0,
                          right: 16.0,
                          left: 16.0,
                          bottom: 8.0
                      ),
                    child: Row(
                      children: [
                        Expanded(
                          child: statisticsCard(
                            title: "Speed",
                            secondText: "Max",
                            measureUnit: "km/h",
                            valueNotifier: widget.speedNotifier,
                            iconData: Icons.speed,
                            convertSpeed: true,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: statisticsCard(
                            title: "Speed",
                            secondText: "Average",
                            measureUnit: "km/h",
                            valueNotifier: widget.averageSpeedNotifier,
                            iconData: Icons.speed,
                            convertSpeed: true,
                          ),
                        ),
                      ],
                    )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          right: 16.0,
                          left: 16.0,
                          bottom: 8.0
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: statisticsCard(
                              title: "Distance",
                              secondText: "Total",
                              measureUnit: "km",
                              valueNotifier: widget.totalDistanceNotifier,
                              iconData: Icons.double_arrow,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: statisticsCard(
                              title: "Altitude",
                              secondText: "Max",
                              measureUnit: "m",
                              valueNotifier: widget.maxAltitudeNotifier,
                              iconData: Icons.height,
                            ),
                          ),
                        ],
                      )
                  ),
                  const Padding(
                      padding: EdgeInsets.only(
                          right: 16.0,
                          left: 16.0,
                          bottom: 8.0
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: statisticsCard(
                              title: "Stop time",
                              valueNotifier: null,
                              iconData: Icons.hourglass_empty,
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: statisticsCard(
                              title: "Runs",
                              valueNotifier: null,
                              iconData: Icons.sync_alt,
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

