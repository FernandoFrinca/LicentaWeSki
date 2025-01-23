import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:weski/Api/skiSlopeAPI.dart';
import 'package:weski/Pages/ProfilePage.dart';
import 'package:weski/Widget/customButton.dart';
import 'package:weski/Api/skiResortAPI.dart';

class customDrawer extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const customDrawer({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: screenWidth * 0.85,
      backgroundColor: Colors.white,
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
                    "Hello, Username!",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Divider(color: Colors.grey.shade300, thickness: 1.0),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customButton(
                      data: "My profile",
                      icon: Icons.account_circle_sharp,
                      iconColor: 0xFF000000,
                      textColor: 0xFF000000,
                      textSize: screenWidth * 0.045,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      paddingWidth: 0.06,
                      paddingHeight: 0.01,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      },
                      iconSize: screenWidth * 0.08,
                      paddingText: screenWidth * 0.03
                  ),
                  customButton(
                      data: "Sensors",
                      icon: Icons.sensors_rounded,
                      iconColor: 0xFF000000,
                      textColor: 0xFF000000,
                      textSize: screenWidth * 0.045,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      paddingWidth: 0.06,
                      paddingHeight: 0.01,
                      onTap: (){

                      },
                      iconSize: screenWidth * 0.08,
                      paddingText: screenWidth * 0.03
                  ),
                  customButton(
                      data: "Notifications",
                      icon: Icons.notifications_none,
                      iconColor: 0xFF000000,
                      textColor: 0xFF000000,
                      textSize: screenWidth * 0.045,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      paddingWidth: 0.06,
                      paddingHeight: 0.01,
                      onTap: () async {
                        final response = await skiSlopeApi.fetchSlopesfromResort(1);
                        print('API Response: $response');
                      },
                      iconSize: screenWidth * 0.08,
                      paddingText: screenWidth * 0.03
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300, thickness: 1.0),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.06,
                right: screenWidth * 0.06,
                bottom: screenHeight * 0.03,
              ),
              child: GestureDetector(
                onTap: (){},
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
                        color: Colors.black,
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
