import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';

import '../Assets/Theme.dart';
import '../Widget/sensorsCard.dart';
import '../Assets/BLELogic.dart';


class SensorPage extends StatefulWidget {
  const SensorPage({super.key});

  @override
  SensorPageState createState() => SensorPageState();
}

class SensorPageState extends State<SensorPage> {
  late ValueNotifier<String> ldrNotifier = new ValueNotifier("empty");
  DiscoveredDevice dummyDevice =
  DiscoveredDevice(
    id: "",
    name: "no device connected",
    serviceUuids: const [],
    rssi: 0,
    connectable: Connectable.unavailable,
    serviceData: const {},
    manufacturerData: Uint8List(0),
  );
  final bleController = Get.put(BLELogic());
  late bool isScanning = false;
  Color buttonColorLight = Colors.red;
  int buttonLightState = 0;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        bleController.readLdrValue(ldrNotifier);
      }
    });
  }

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
              height: (screenDiagonal >= 720 && screenDiagonal <= 740)
                  ? screenHeight * 0.275
                  : screenHeight * 0.26,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                color: Color(0xFFD3D3D3),
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
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.015,
                          left: screenWidth * 0.07,
                          right: screenWidth * 0.07,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Color(theme.colorScheme.surface.value),
                          ),
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.07,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: screenDiagonal * 0.02,
                                  right: screenDiagonal * 0.01,
                                ),
                                child: Text(
                                  "Connected:",
                                  style: TextStyle(
                                    fontSize: screenDiagonal * 0.02,
                                    fontWeight: FontWeight.bold,
                                    color: Color(theme.colorScheme.onSurface.value),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: screenDiagonal * 0.02,
                                    ),
                                    child: ValueListenableBuilder<DiscoveredDevice>(
                                      valueListenable: bleController.connectedDeviceNotifier,
                                      builder: (context, device, child) {
                                        return Text(
                                          device.name,
                                          style: TextStyle(
                                            fontSize: screenDiagonal * 0.02,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.07, top: screenHeight * 0.010, right: screenWidth * 0.07),
                        child: Row(
                          children: [
                            Expanded(
                              child: sensorsCard(
                                title: "Light",
                                secondText: "sensor",
                                iconData: Icons.lightbulb_outline_sharp,
                                valueNotifier: ldrNotifier,
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top:screenHeight*0.01
                                    ),
                                    child: RawMaterialButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () {
                                        setState(() {
                                          if (buttonLightState == 0) {
                                            buttonLightState = 1;
                                            bleController.sendCommandToDevice(1);
                                            buttonColorLight = Colors.green;
                                          } else if (buttonLightState == 1) {
                                            buttonLightState = 2;
                                            bleController.sendCommandToDevice(2);
                                          } else {
                                            buttonLightState = 0;
                                            bleController.sendCommandToDevice(0);
                                            buttonColorLight = Colors.red;
                                          }
                                        });
                                      },
                                      child: CircleAvatar(
                                        radius: screenDiagonal * 0.03,
                                        backgroundColor: Colors.white,
                                        child: buttonLightState == 2
                                            ? Text(
                                          "Auto",
                                          style: TextStyle(color: buttonColorLight),
                                        )
                                            : Icon(
                                          Icons.power_settings_new_outlined,
                                          color: buttonColorLight,
                                          size: screenDiagonal * 0.035,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      Icon(
                                        Icons.sos_sharp,
                                        size: screenDiagonal * 0.04,
                                        color: Colors.red,
                                      ),
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            switchTheme: SwitchThemeData(
                                              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                            ),
                                          ),
                                          child: Switch(
                                            value: isSwitched,
                                            onChanged: (bool value) {
                                                setState(() {
                                                  isSwitched = value;
                                                });
                                                bleController.sendSOSCommandtoDevice(isSwitched);
                                              },
                                            activeColor: Colors.white,
                                            activeTrackColor: Colors.green,
                                            inactiveThumbColor: Colors.white,
                                            inactiveTrackColor: Colors.black12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
              child: Text("Avalible connections:", style: TextStyle(fontSize: screenDiagonal * 0.03, fontWeight: FontWeight.bold, color: Color(theme.colorScheme.onTertiary.value),),)
          ),
          Positioned(
            top: screenHeight * 0.325,
            left: 0,
            right: 0,
            bottom: screenHeight * 0.06,
            child: Obx(() => ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              itemCount: bleController.devices.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 2, color: Colors.grey.shade300),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                   bool conectionStatus = await bleController.connectTODevice(bleController.devices[index]);
                   if(conectionStatus == true){
                     bleController.connectedDeviceNotifier.value = bleController.devices[index];
                   }else{
                     bleController.connectedDeviceNotifier.value = dummyDevice;
                   }

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.020,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bleController.devices[index].name,
                          style: TextStyle(
                            fontSize: screenDiagonal * 0.022,
                            fontWeight: FontWeight.w500,
                            color: Color(theme.colorScheme.primary.value),
                          ),
                        ),
                        Text(
                          bleController.devices[index].id,
                          style: TextStyle(
                            fontSize: screenDiagonal * 0.015,
                            fontWeight: FontWeight.w500,
                            color: theme.brightness == lightTheme.brightness? Colors.black26 : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
          ),
          Positioned(
            top: screenHeight * 0.78,
            left: screenWidth * 0.75,
            child: RawMaterialButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () async {
                if(isScanning == false) {
                  await bleController.scanForDevices();
                  setState(() {
                    isScanning = !isScanning;
                  });
                }else{
                  await bleController.stopScan();
                  setState(() {
                    isScanning = !isScanning;
                  });
                }
              },
              child: CircleAvatar(
                radius: screenDiagonal * 0.035,
                backgroundColor: Color(theme.colorScheme.primary.value),
                child: Icon(isScanning? Icons.bluetooth_searching_outlined : Icons.bluetooth_disabled_outlined, color: Colors.white, size: screenDiagonal * 0.035,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}