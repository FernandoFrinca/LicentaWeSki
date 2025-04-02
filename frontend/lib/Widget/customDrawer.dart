import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:weski/Api/groupApi.dart';
import 'package:weski/Api/locationApi.dart';
import 'package:weski/Api/notificationApi.dart';
import 'package:weski/Api/skiResortAPI.dart';
import 'package:weski/Api/userApi.dart';
import 'package:weski/Pages/ChatBotPage.dart';
import 'package:weski/Pages/NotificationPage.dart';
import 'package:weski/Pages/ProfilePage.dart';
import 'package:weski/Pages/SensorPage.dart';
import 'package:weski/Widget/customButton.dart';
import '../Assets/LocationLogic.dart';
import '../Assets/Theme.dart';
import '../ConcretObjects/User.dart';
import '../Pages/LoginPage.dart';

class customDrawer extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final User? user;

  const customDrawer({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));
    return Drawer(
      width: screenWidth * 0.85,
      backgroundColor: Color(theme.colorScheme.surface.value),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.01,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: screenHeight * 0.04,
                    height: screenHeight * 0.04,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  AutoSizeText(
                    "Hello, ${user?.getUsername() ?? 'Guest'}!",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Color(theme.colorScheme.onSurface.value),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Divider(color: theme.brightness == lightTheme.brightness? Colors.black26 : Colors.white24, thickness: 1.0),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customButton(
                      data: "My profile",
                      icon: Icons.account_circle_sharp,
                      iconColor: theme.colorScheme.onSurface.value,
                      textColor: theme.colorScheme.onSurface.value,
                      textSize: screenWidth * 0.045,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      paddingWidth: 0.06,
                      paddingHeight: 0.01,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(curentUser: user,),
                          ),
                        );
                      },
                      iconSize: screenWidth * 0.08,
                      paddingText: screenWidth * 0.03
                  ),
                  customButton(
                      data: "Chat Bot",
                      icon: Icons.chat_outlined,
                      iconColor: theme.colorScheme.onSurface.value,
                      textColor: theme.colorScheme.onSurface.value,
                      textSize: screenWidth * 0.045,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      paddingWidth: 0.06,
                      paddingHeight: 0.01,
                      onTap: () async {
                        LocationData currentLocation = await getCurrentLocation();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatBotPage(cuentLocation: currentLocation,)),
                        );
                      },
                      iconSize: screenWidth * 0.08,
                      paddingText: screenWidth * 0.03
                  ),
                  customButton(
                      data: "Notifications",
                      icon: Icons.notifications_none,
                      iconColor: theme.colorScheme.onSurface.value,
                      textColor: theme.colorScheme.onSurface.value,
                      textSize: screenWidth * 0.045,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      paddingWidth: 0.06,
                      paddingHeight: 0.01,
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationPage(curentUserId:user!.id,),
                          ),
                        );
                      },
                      iconSize: screenWidth * 0.08,
                      paddingText: screenWidth * 0.03
                  ),
                  customButton(
                      data: "Sensors",
                      icon: Icons.sensors_rounded,
                      iconColor: theme.colorScheme.onSurface.value,
                      textColor: theme.colorScheme.onSurface.value,
                      textSize: screenWidth * 0.045,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      paddingWidth: 0.06,
                      paddingHeight: 0.01,
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SensorPage(),
                          ),
                        );
                      },
                      iconSize: screenWidth * 0.08,
                      paddingText: screenWidth * 0.03
                  ),
                  customButton(
                      data: "test",
                      icon: Icons.adb,
                      iconColor: theme.colorScheme.onSurface.value,
                      textColor: theme.colorScheme.onSurface.value,
                      textSize: screenWidth * 0.045,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      paddingWidth: 0.06,
                      paddingHeight: 0.01,
                      onTap: () async {
/*                        LocationData currentLocation = await getCurrentLocation();
                        print("");
                        print("locatie:");
                        print(currentLocation.longitude);
                        print(currentLocation.latitude);
                        print("");
                        print("");
                        await skiResortApi.fetchResortsData();*/
                        //print(await userApi.fetchProfilePicture(1));
                        await userApi.updateProfilePicture(2,"url-prin-flutter");
                      },
                      iconSize: screenWidth * 0.08,
                      paddingText: screenWidth * 0.03
                  ),
                ],
              ),
            ),
            Divider(color: theme.brightness == lightTheme.brightness? Colors.black26 : Colors.white24, thickness: 1.0),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.06,
                right: screenWidth * 0.06,
                bottom: screenHeight * 0.03,
              ),
              child: GestureDetector(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        content: Container(
                          width: screenWidth * 0.2,
                          height: screenHeight * 0.11,
                          decoration: BoxDecoration(
                            color: Color(theme.colorScheme.surface.value),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Are you sure?", style: TextStyle(fontSize: screenDiagonal * 0.025),),
                              Padding(
                                padding: EdgeInsets.only(
                                    left:screenWidth * 0.07
                                ),
                                child: customButton(
                                  data: "Logout",
                                  icon: Icons.logout,
                                  iconColor: 0xFFF20000,
                                  textColor: theme.colorScheme.onSurface.value,
                                  textSize: screenWidth * 0.04,
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                  paddingWidth: 0.13,
                                  paddingHeight: 0.01,
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginPage()),
                                          (Route<dynamic> route) => false,
                                    );
                                  },
                                  iconSize: screenWidth * 0.08,
                                  paddingText: screenWidth * 0.01,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.logout,
                      size: screenWidth * 0.06,
                      color: Colors.redAccent,
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    AutoSizeText(
                      "Logout",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Color(theme.colorScheme.onSurface.value),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
